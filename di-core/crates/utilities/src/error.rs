use std::fmt::Debug;
use thiserror::Error;

pub type Result<T> = std::result::Result<T, Error>;

#[derive(Error, Debug)]
pub enum Error {
    #[error("Failed while starting main function!")]
    MainFailure,

    #[error("File is probably non existent: {0}")]
    NonExistent(String),

    #[error("Error while reading/writing: {0}")]
    IO(#[from] std::io::Error),

    #[error("Error while processing .env variables: {0}")]
    EnvLoad(#[from] dotenvy::Error),

    #[error("Error while getting a variable: {0}")]
    EnvRead(#[from] std::env::VarError),

    #[error("Error while parsing numbers from string, are you sure you typed normal number in configs?: {0}")]
    NumberConversion(#[from] std::num::ParseIntError),

    #[error("Error while serializing configuration to a file: {0}")]
    Serialization(#[from] toml::ser::Error),

    #[error("Error while deserializing configuration to a file: {0}")]
    Deserialization(#[from] toml::de::Error),

    #[error("database issue: {0}")]
    DatabaseError(#[from] diesel::result::Error),

    #[error("user already exists: {0}")]
    UserExists(String),

    #[error("couldn't get a pool from database: {0}")]
    PoolError(#[from] r2d2::Error),

    #[error("seems like, there are no such user with email: {0}")]
    UserDoesntExist(String),

    #[error("there was an error with (un)hashing password: {0}")]
    Hashing(argon2::password_hash::Error),

    #[error("the attempting user seems invalid (failed login attempt): {0}")]
    InvalidUser(String),

    #[error("there's an error with creating a jwt token: {0}")]
    TokenError(#[from] jsonwebtoken::errors::Error),
}
