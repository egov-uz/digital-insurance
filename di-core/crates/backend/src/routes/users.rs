use crate::response::{DIResponse, ToDIResponse};
use crate::{jwt::TokenClaims, AppState};
use actix_web::cookie::{time::Duration as WebDuration, Cookie};
use actix_web::{error, get, web, HttpResponse, Responder};
use chrono::{Duration, Utc};
use database::users::{LoginUser, NewUser};
use jsonwebtoken::{jws::encode, EncodingKey, Header};
use utilities::error::Error;

#[get("/auth/register")]
async fn user_register(
    state: web::Data<AppState>,
    body: web::Json<NewUser>,
) -> actix_web::Result<impl Responder> {
    web::block(move || {
        let mut conn = state.db.get()?;

        database::users::insert_new_user(&mut conn, &body.clone())
    })
    .await?
    .map_err(error::ErrorInternalServerError)?;

    Ok(HttpResponse::Ok().json(DIResponse::new("success", "Aight, cooked")))
}

#[get("/auth/login")]
async fn get_post(
    state: web::Data<AppState>,
    body: web::Json<LoginUser>,
) -> actix_web::Result<impl Responder> {
    let user = web::block(move || {
        let mut conn = state.db.get()?;

        database::users::check_legit(&mut conn, &body)
    })
    .await?
    // map diesel query errors to a 500 error response
    .map_err(error::ErrorInternalServerError)?;

    let now = Utc::now();
    let iat = now.timestamp() as usize;
    let exp = (now + Duration::minutes(60)).timestamp() as usize;

    let claims = TokenClaims {
        exp,
        iat,
        sub: user.to_string(),
    };

    let token = encode(
        &Header::default(),
        Some(&claims),
        &EncodingKey::from_secret(state.config.jwt_secret.as_ref()),
    )
    .map_err(Error::TokenError)
    .map_err(|e| e.to_request())?;

    let cookie = Cookie::build("token", token)
        .path("/")
        .max_age(WebDuration::new(60 * 60, 0))
        .http_only(true)
        .finish();

    Ok(HttpResponse::Ok()
        .cookie(cookie)
        .json(serde_json::json!({"status": "success", "token": token})))
}

// #[post("/auth/logout")]
// async fn new_post(
//     pool: web::Data<DbPool>,
//     form: web::Json<NewPost>,
// ) -> actix_web::Result<impl Responder> {
//     // use web::block to offload blocking Diesel queries without blocking server thread
//     let post = web::block(move || {
//         // note that obtaining a connection from the pool is also potentially blocking
//         let mut conn = pool.get()?;

//         database::posts::insert_new_post(&mut conn, &form.title, &form.body)
//     })
//     .await?
//     // map diesel query errors to a 500 error response
//     .map_err(error::ErrorInternalServerError)?;

//     // post was added successfully; return 201 response with new user info
//     Ok(HttpResponse::Created().json(post))
// }

// #[put("/users/me")]
// async fn edit_post(
//     pool: web::Data<DbPool>,
//     path: web::Path<(i32,)>,
//     form: web::Json<UpdatePost>,
// ) -> actix_web::Result<impl Responder> {
//     let post_id = path.into_inner().0;

//     // use web::block to offload blocking Diesel queries without blocking server thread
//     let update = web::block(move || {
//         // note that obtaining a connection from the pool is also potentially blocking
//         let mut conn = pool.get()?;

//         database::posts::update_post(&mut conn, post_id, &form.into_inner())
//     })
//     .await?
//     // map diesel query errors to a 500 error response
//     .map_err(error::ErrorInternalServerError)?;

//     // post was added successfully; return 201 response with new user info
//     Ok(HttpResponse::Ok().json(update))
// }
