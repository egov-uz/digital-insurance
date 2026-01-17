// @generated automatically by Diesel CLI.

diesel::table! {
    users (id) {
        id -> Uuid,
        #[max_length = 100]
        username -> Varchar,
        #[max_length = 255]
        email -> Varchar,
        verified -> Bool,
        #[max_length = 100]
        password -> Varchar,
        #[max_length = 50]
        role -> Varchar,
        created_at -> Nullable<Timestamptz>,
        updated_at -> Nullable<Timestamptz>,
    }
}
