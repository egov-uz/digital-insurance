use serde::{Deserialize, Serialize};
use utilities::error::Error;

pub trait ToDIResponse {
    fn to_request(self) -> DIResponse;
}

#[derive(Debug, Serialize, Deserialize, Default)]
pub struct DIResponse {
    pub status: String,
    pub message: String,
}

impl DIResponse {
    pub fn new<S, M>(status: S, message: M) -> Self
    where
        S: ToString,
        M: ToString,
    {
        Self {
            status: status.to_string(),
            message: message.to_string(),
        }
    }

    pub fn success<M>(message: M) -> Self
    where
        M: ToString,
    {
        Self::new("success".to_string(), message.to_string())
    }

    pub fn error<M>(message: M) -> Self
    where
        M: ToString,
    {
        Self::new("error".to_string(), message.to_string())
    }
}

impl std::fmt::Display for DIResponse {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", serde_json::to_string(&self).unwrap())
    }
}

impl ToDIResponse for Error {
    fn to_request(self) -> DIResponse {
        DIResponse::new("error", self)
    }
}

impl actix_web::error::ResponseError for DIResponse {}
