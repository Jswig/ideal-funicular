module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Time
import Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , time : Time.Posix
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key url (Time.millisToPosix 0), Cmd.none )


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        [ mainHeader
        , text "The current URL is: "
        , b [] [ text (Url.toString model.url) ]
        , mainFooter
        ]
    }


mainHeader : Html msg
mainHeader =
    header []
        [ text "Anders Poirel", navBar ]


navBar : Html msg
navBar =
    div []
        [ navBarLink "/home"
        , navBarLink "/about"
        , navBarLink "/blog"
        , navBarLink "/code"
        ]


navBarLink : String -> Html msg
navBarLink path =
    div [] [ a [ href path ] [ text path ] ]


mainFooter : Html msg
mainFooter =
    footer [] [ text "© 2022 Anders Poirel" ]
