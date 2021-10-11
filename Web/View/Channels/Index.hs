module Web.View.Channels.Index where
import Web.View.Prelude

data IndexView = IndexView { channels :: [Channel] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <h1>Channels <a href={pathTo NewChannelAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Channel</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach channels renderChannel}</tbody>
            </table>
        </div>
    |]


renderChannel :: Channel -> Html
renderChannel channel = [hsx|
    <tr>
        <td>
            <a href={ShowChannelAction (get #id channel)}>
                {get #name channel}
            </a>
        </td>
        <td><a href={EditChannelAction (get #id channel)} class="text-muted">Rename</a></td>
        <td><a href={DeleteChannelAction (get #id channel)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
