-- Module & Imports


module Listings exposing (..)

import Html.Attributes exposing (..)
import Html exposing (..)
import Html.App as App exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Task exposing (Task)
import Json.Decode as Json exposing ((:=))


--------------------------------------------------------------------------------
-- Model


type alias Model =
    { helloWorld : String
    , pageName : String
    , message : String
    , listings : List ListingInfo
    }


type Msg
    = NoOp
    | GetListings
    | ErrorOccurred String
    | ListingsFetched (List ListingInfo)


type alias ListingInfo =
    { id : Int
    , address : String
    , city : String
    , state : String
    , zip : String
    , price : Int
    , description : String
    , notes : String
    }


type Error
    = Timeout
    | NetworkError
    | UnexpectedPayload String
    | BadResponse Int String


initModel =
    let
        model =
            { helloWorld = "Hello World!"
            , pageName = "Listings"
            , message = "Click to get Listings"
            , listings = []
            }
    in
        model ! [ getListings ]



--------------------------------------------------------------------------------
-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        GetListings ->
            { model | message = "Getting listings" } ! [ getListings ]

        ErrorOccurred errorMessage ->
            { model | message = "An error occurred: " ++ errorMessage } ! []

        ListingsFetched listings ->
            { model | listings = listings, message = "Retrieved listings" } ! []



--------------------------------------------------------------------------------
-- View


view : Model -> Html Msg
view model =
    let
        showListing listing =
            div
                [ class "panel panel-default agent-card" ]
                [ div
                    [ class "panel-heading" ]
                    [ h3
                        [ class "panel-title" ]
                        [ text <| listing.address ]
                    , h6 []
                        [ text <| listing.city ]
                    ]
                , div
                    [ class "panel-body" ]
                    [ ul [ attribute "style" "list-style: none;" ]
                        [ li []
                            [ text <| (listing.city ++ ", " ++ listing.state ++ " - " ++ listing.zip) ]
                        , li []
                            [ text <| "$" ++ (toString listing.price) ]
                        , hr [] []
                        , li []
                            [ text ("Description: " ++ listing.description) ]
                        , hr [] []
                        , li []
                            [ text ("Notes: " ++ listing.notes) ]
                        ]
                    ]
                ]
    in
        div []
            [ ul [] (List.map showListing model.listings)
            , hr [] []
            ]


formView : Model -> Html Model
formView model =
    div []
        [ p [] [ text model.helloWorld ]
        , p [] [ text model.pageName ]
        , div []
            [ h3 [] [ text "New Listing" ]
            , Html.form []
                [ input
                    [ type' "text"
                      -- , onInput AddressInput
                    , placeholder "Address - 1234 Main St."
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput CityInput
                    , placeholder "City - Gunnison"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput StateInput
                    , placeholder "State - CO"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput ZipInput
                    , placeholder "Zip - 80534"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput PriceInput
                    , placeholder "Price - 199900"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput DescInput
                    , placeholder "Description"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput NotesInput
                    , placeholder "Notes"
                    ]
                    []
                , br [] []
                , input
                    [ type' "submit" ]
                    [ text "Submit" ]
                ]
            ]
        , hr [] []
        , div []
            [ h3 []
                [ text "Listings" ]
            , div
                []
                [ img [] []
                , h5 [] [ text "ADDRESS" ]
                , br [] []
                , p [] [ text "Price" ]
                , br [] []
                , p [] [ text "Description" ]
                ]
            , div
                []
                [ img [] []
                , h5 [] [ text "ADDRESS" ]
                , br [] []
                , p [] [ text "Price" ]
                , br [] []
                , p [] [ text "Description" ]
                ]
            ]
        ]



--------------------------------------------------------------------------------
-- Listings


listingInfoDecoder : Json.Decoder ListingInfo
listingInfoDecoder =
    Json.object8
        ListingInfo
        ("id" := Json.int)
        ("address" := Json.string)
        ("city" := Json.string)
        ("state" := Json.string)
        ("zip" := Json.string)
        ("price" := Json.int)
        ("description" := Json.string)
        ("notes" := Json.string)


listingInfoListDecoder : Json.Decoder (List ListingInfo)
listingInfoListDecoder =
    Json.list listingInfoDecoder


getListings : Cmd Msg
getListings =
    Http.get listingInfoListDecoder "https://clarkeagency.herokuapp.com/listings"
        --"http://localhost:3000/listings"
        |>
            Task.mapError toString
        |> Task.perform ErrorOccurred ListingsFetched


customGetListings : Task RawError Response
customGetListings =
    send defaultSettings
        { verb = "GET"
        , headers =
            [ ( "Accept", "application/json" )
            , ( "Content-Type", "application/json" )
            , ( "Authorization", "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidXNlcm5hbWUiOiJnYWJlIiwiaWF0IjoxNDc0MTQxMTkwfQ.Hpydi6C7Hr0f8aNbZtY3G8ybrjynmjITuZgsqt3MrZs" )
            ]
        , url = "http://localhost:3000/listings"
        , body = empty
        }


type alias Request =
    { verb : String
    , headers : List ( String, String )
    , url : String
    , body : Body
    }



--------------------------------------------------------------------------------
-- Main


main : Program Never
main =
    App.program
        { init = initModel
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
