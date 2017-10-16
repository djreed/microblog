// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

let postInput         = document.querySelector("#post-form")
let allPosts          = document.querySelector("#all-posts")
let currentUserName   = document.querySelector("#current-user-name")
let currentUserHandle = document.querySelector("#current-user-handle")
let postContent       = document.querySelector("#post-content")

postInput.addEventListener("submit", function(e) {
    channel.push("add_post", {
        name: currentUserName.textContent,
        handle: currentUserHandle.textContent,
        content: postContent.value
    })
});

let channel = socket.channel("updates:all", {})

channel.on("add_post", payload => {
    console.log(`new post: ${payload}`)

    let card = document.createElement("div")
    card.setAttribute("class", "card m-2 mb-4 card-outline-primary")

    // Card header
    let cardHeader = document.createElement("div")
    cardHeader.setAttribute("class", "card-header")

    let cardTitle = document.createElement("span")
    cardTitle.setAttribute("class", "card-title")
    cardTitle.innerHTML = `${payload.name}`

    let cardSubtitle = document.createElement("span")
    cardSubtitle.setAttribute("class", "card-subtitle")
    cardSubtitle.innerHTML = `(${payload.handle})`

    cardHeader.appendChild(cardTitle)
    cardHeader.appendChild(cardSubtitle)

    // Card body
    let cardBlock = document.createElement("div")
    cardBlock.setAttribute("class", "card-block")

    let cardBlockRow = document.createElement("div")
    cardBlockRow.setAttribute("class", "row m-2")

    let cardContent = document.createElement("p")
    cardContent.setAttribute("class", "card-text col-md-9 my-2")
    cardContent.innerHTML = `${payload.content}`

    cardBlockRow.appendChild(cardContent)
    cardBlock.appendChild(cardBlockRow)

    // Card footer
    let cardFooter = document.createElement("div")
    cardFooter.setAttribute("class", "card-footer")

    let footerLeft = document.createElement("div")
    footerLeft.setAttribute("class", "float-left")

    let cardTime = document.createElement("span")
    cardTime.setAttribute("class", "btn btn-sm text-muted")
    cardTime.innerHTML = `Posted: now`

    footerLeft.appendChild(cardTime)
    cardFooter.appendChild(footerLeft)

    // Build the card
    card.appendChild(cardHeader)
    card.appendChild(cardBlock)
    card.appendChild(cardFooter)

    allPosts.prepend(card)
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
