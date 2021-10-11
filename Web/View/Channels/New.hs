module Web.View.Channels.New where
import Web.View.Prelude

data NewView = NewView { channel :: Channel }

instance View NewView where
    html NewView { .. } = [hsx|
        <div class="pt-4">
            <a href={ChannelsAction}>← Chat</a>
            <h1>New Channel</h1>
            {renderForm channel}
        </div>
    |]

renderForm :: Channel -> Html
renderForm channel = formFor channel [hsx|
    {(textField #name)}
    {submitButton}
|]
