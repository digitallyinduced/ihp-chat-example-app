module Web.View.Channels.Show where
import Web.View.Prelude

data ShowView = ShowView
    { channel :: Include "messages" Channel
    , users :: [User]
    , channels :: [Channel]
    }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <div class="row">
            <div class="col-3 bg-light pt-4">
                <ul class="nav nav-pills flex-column">
                    {forEach channels renderChannelNavigation}
                    <li class="nav-item">
                        <a class="nav-link" href={NewChannelAction}>+ New Channel</a>
                    </li>
                </ul>

                <hr />
                <a href={DeleteSessionAction} class="js-delete js-delete-no-confirm text-muted" style="font-size: 12px">← Logout {currentUser.email}</a>
            </div>

            <div class="col-9">
                <div class="messages">
                    {forEach messages (renderMessage users)}
                </div>
                {newMessageForm}
            </div>
        </div>
    |]
        where
            messages = channel.messages

            newMessageForm = formFor message  [hsx|
                {hiddenField #channelId}
                {(textField #body) { autofocus = True, disableLabel = True, placeholder = bodyPlaceholder }}
                {submitButton}
            |]
                where
                    message = newRecord @Message
                            |> set #channelId (channel.id)

                    bodyPlaceholder = "Send message to #" <> channel.name

getUserEmail :: Id User -> [User] -> Text
getUserEmail id users =
    maybe "" (get #email) $ find (\u -> id == (u.id)) users

renderMessage :: [User] -> Message -> Html
renderMessage users message = [hsx|
    <div class="message">
        <img src="https://picsum.photos/64/64" loading="lazy">
        <div class="flex-grow-1">
            <div class="header">
                <div class="d-flex align-items-center">
                    <div class="message-author">{getUserEmail (message.userId) users}</div>
                    {when (currentUser.id == message.userId) messageActions}
                </div>
                <div class="created-at">
                    {message.createdAt |> timeAgo}
                </div>
            </div>
            <div class="message-body">
                {message.body}
            </div>
        </div>
    </div>
|]
    where
        messageActions = [hsx|
            <div class="actions">
                <a href={DeleteMessageAction (message.id)} class="js-delete text-muted">
                    Delete message
                </a>
                <a href={EditMessageAction (message.id)} class="text-muted">
                    Edit Message
                </a>
            </div>
        |]

renderChannelNavigation :: Channel -> Html
renderChannelNavigation Channel { .. } = [hsx|
    <li class="nav-item">
        <a class={classes ["nav-link", ("active", isActive)]} href={ShowChannelAction id}>{"#" <> name}</a>
    </li>
|]
    where
        isActive = isActivePath $ ShowChannelAction id
