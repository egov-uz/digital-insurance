mod jwt;
mod response;
mod routes;

use actix_web::{web, App, HttpServer};
use database::{
    r2d2::{self, ConnectionManager, Pool},
    PgConnection,
};
use utilities::config::Config;

pub struct AppState {
    config: Config,
    db: Pool<ConnectionManager<PgConnection>>,
}

pub async fn server(config: Config) -> std::io::Result<()> {
    // Logger setup
    env_logger::init_from_env(env_logger::Env::new().default_filter_or("trace"));

    let manager = r2d2::ConnectionManager::<PgConnection>::new(config.database_url.clone());
    let pool = r2d2::Pool::builder()
        .build(manager)
        .expect("seems like something is wrong with database_url coming from config!");

    let conf_state = config.clone();

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(AppState {
                db: pool.clone(),
                config: conf_state.clone(),
            }))
            .service(routes::index)
            .service(routes::users::user_register)
    })
    .workers(config.threads as usize)
    .bind(config.socket_addr().unwrap_or("127.0.0.1:8000".to_string()))?
    .run()
    .await
}
