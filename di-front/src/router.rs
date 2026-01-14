use yew::prelude::*;
use yew_router::prelude::*;

use crate::pages::{
    home_page::HomePage, login_page::LoginPage, profile_page::ProfilePage,
    register_page::RegisterPage,
};

#[derive(Clone, Routable, PartialEq)]
pub enum Route {
    #[at("/")]
    Home,
    #[at("/register")]
    Register,
    #[at("/login")]
    Login,
    #[at("/profile")]
    Profile,
}

pub fn switch(routes: Route) -> Html {
    match routes {
        Route::Home => html! {<HomePage/> },
        Route::Register => html! {<RegisterPage/> },
        Route::Login => html! {<LoginPage/> },
        Route::Profile => html! {<ProfilePage/> },
    }
}
