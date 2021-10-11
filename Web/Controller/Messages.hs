module Web.Controller.Messages where

import Web.Controller.Prelude
import Web.View.Messages.Edit
import Web.Controller.Channels ()

instance Controller MessagesController where
    -- Only allow access for logged in users
    beforeAction = ensureIsUser

    action EditMessageAction { messageId } = do
        message <- fetch messageId

        -- Only allow editing if the message is created by the current user
        accessDeniedUnless (get #userId message == currentUserId)

        setModal EditView { .. }
        jumpToAction ShowChannelAction { channelId = get #channelId message }

    action UpdateMessageAction { messageId } = do
        message <- fetch messageId

        -- Only allow editing if the message is created by the current user
        accessDeniedUnless (get #userId message == currentUserId)

        message
            |> fill @'["body"]
            |> validateField #body nonEmpty
            |> ifValid \case
                Left message -> do
                    setModal EditView { .. }
                    jumpToAction ShowChannelAction { channelId = get #channelId message }
                Right message -> do
                    message <- message |> updateRecord
                    redirectTo ShowChannelAction { channelId = get #channelId message }

    action CreateMessageAction = do
        let message = newRecord @Message
        message
            |> fill @["channelId", "body"]
            |> validateField #body nonEmpty
            |> set #userId currentUserId
            |> ifValid \case
                Left message -> redirectTo ShowChannelAction { channelId = get #channelId message }
                Right message -> do
                    message <- message |> createRecord

                    let channelId = get #channelId message
                    redirectTo ShowChannelAction { channelId }

    action DeleteMessageAction { messageId } = do
        message <- fetch messageId
        
        -- Only allow editing if the message is created by the current user
        accessDeniedUnless (get #userId message == currentUserId)

        deleteRecord message
        redirectTo ShowChannelAction { channelId = get #channelId message }
