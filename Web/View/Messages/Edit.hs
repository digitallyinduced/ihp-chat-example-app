module Web.View.Messages.Edit where
import Web.View.Prelude

data EditView = EditView { message :: Message }

instance View EditView where
    html EditView { .. } = renderModal Modal
                { modalTitle = "Edit Message"
                , modalCloseUrl = pathTo ShowChannelAction { channelId = get #channelId message }
                , modalFooter = Nothing
                , modalContent = [hsx|
                        {renderForm message}
                    |]
                }

renderForm :: Message -> Html
renderForm message = formFor message [hsx|
    {(textField #body) { disableLabel = True, autofocus = True }}
    {submitButton}
|]
