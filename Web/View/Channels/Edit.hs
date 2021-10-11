module Web.View.Channels.Edit where
import Web.View.Prelude

data EditView = EditView { channel :: Channel }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={ChannelsAction}>Channels</a></li>
                <li class="breadcrumb-item active">Edit Channel</li>
            </ol>
        </nav>
        <h1>Edit Channel</h1>
        {renderForm channel}
    |]

renderForm :: Channel -> Html
renderForm channel = formFor channel [hsx|
    {(textField #name)}
    {submitButton}
|]
