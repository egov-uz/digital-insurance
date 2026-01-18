use crate::schema::users;
use argon2::{
    password_hash::{rand_core::OsRng, PasswordHasher, SaltString},
    Argon2, PasswordHash, PasswordVerifier,
};
use chrono::prelude::*;
use diesel::prelude::*;
use serde::{Deserialize, Serialize};
use utilities::error::{Error, Result};
use uuid::Uuid;

#[derive(Queryable, Selectable, Serialize, Deserialize, Debug, Clone)]
#[diesel(table_name = users)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct User {
    pub id: uuid::Uuid,
    pub username: String,
    pub email: String,
    pub password: String,
    pub role: String,
    pub verified: bool,
    #[serde(rename = "createdAt")]
    pub created_at: Option<DateTime<Utc>>,
    #[serde(rename = "updatedAt")]
    pub updated_at: Option<DateTime<Utc>>,
}

#[derive(Insertable, Serialize, Deserialize, Debug, Clone)]
#[diesel(table_name = users)]
pub struct NewUser {
    pub username: String,
    pub email: String,
    pub password: String,
}

impl NewUser {
    fn hash_password(self) -> Self {
        let salt = SaltString::generate(&mut OsRng);

        let hash = Argon2::default()
            .hash_password(self.password.as_bytes(), &salt)
            .expect("Error while hashing password")
            .to_string();

        Self {
            username: self.username,
            email: self.email,
            password: hash,
        }
    }
}

#[derive(Debug, Deserialize)]
pub struct LoginUser {
    pub email: String,
    pub password: String,
}

/// Run query using Diesel to insert a new database row and return the result.
pub fn insert_new_user(conn: &mut PgConnection, bdy: &NewUser) -> Result<()> {
    use crate::schema::users::dsl::*;

    let exists = users
        .filter(email.eq(bdy.email.clone()))
        .select(User::as_select())
        .first(conn)
        .optional()?;

    if exists.is_some() {
        return Err(Error::UserExists(bdy.email.clone()));
    }

    diesel::insert_into(users)
        .values(bdy.clone().hash_password())
        .execute(conn)?;

    Ok(())
}

/// Run query using Diesel to find given user and check vailidity of password
pub fn check_legit(conn: &mut PgConnection, bdy: &LoginUser) -> Result<Uuid> {
    use crate::schema::users::dsl::*;

    let user = users
        .filter(email.eq(bdy.email.clone()))
        .select(User::as_select())
        .first(conn)
        .optional()?
        .ok_or(Error::UserDoesntExist(bdy.email.clone()))?;

    let validity = {
        let hash = PasswordHash::new(&user.password).map_err(Error::Hashing)?;

        Argon2::default()
            .verify_password(bdy.password.as_bytes(), &hash)
            .map_or_else(|_| false, |_| true)
    };

    if !validity {
        return Err(Error::InvalidUser(bdy.email.clone()));
    }

    Ok(user.id)
}

// /// Run query using Diesel to find post by uid and return it.
// pub fn find_post_by_uid(conn: &mut PgConnection, uid: i32) -> Result<Option<Post>, DbError> {
//     use crate::schema::posts::dsl::*;

//     let post = posts.filter(id.eq(uid)).first::<Post>(conn).optional()?;

//     Ok(post)
// }

// /// Run query using Diesel to insert a new database row and return the result.
// pub fn update_post(
//     conn: &mut PgConnection,
//     pid: i32, // prevent collision with `title` column imported inside the function
//     content: &UpdatePost, // prevent collision with `body` column imported inside the function
// ) -> Result<UpdatePost, DbError> {
//     // It is common when using Diesel with Actix Web to import schema-related
//     // modules inside a function's scope (rather than the normal module's scope)
//     // to prevent import collisions and namespace pollution.
//     use crate::schema::posts::dsl::*;

//     diesel::update(posts.find(pid)).set(content).execute(conn)?;

//     Ok(content.clone())
// }

// pub fn remove_post(
//     conn: &mut PgConnection,
//     pid: i32, // prevent collision with `title` column imported inside the function
// ) -> Result<(), DbError> {
//     // It is common when using Diesel with Actix Web to import schema-related
//     // modules inside a function's scope (rather than the normal module's scope)
//     // to prevent import collisions and namespace pollution.
//     use crate::schema::posts::dsl::*;

//     diesel::delete(posts.find(pid)).execute(conn)?;

//     Ok(())
// }
