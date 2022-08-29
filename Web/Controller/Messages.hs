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
        accessDeniedUnless (message.userId == currentUserId)

        setModal EditView { .. }
        jumpToAction ShowChannelAction { channelId = message.channelId }

    action UpdateMessageAction { messageId } = do
        message <- fetch messageId

        -- Only allow editing if the message is created by the current user
        accessDeniedUnless (message.userId == currentUserId)

        message
            |> fill @'["body"]
            |> validateField #body nonEmpty
            |> ifValid \case
                Left message -> do
                    setModal EditView { .. }
                    jumpToAction ShowChannelAction { channelId = message.channelId }
                Right message -> do
                    message <- message |> updateRecord
                    redirectTo ShowChannelAction { channelId = message.channelId }

    action CreateMessageAction = do
        let message = newRecord @Message
        message
            |> fill @["channelId", "body"]
            |> validateField #body nonEmpty
            |> set #userId currentUserId
            |> ifValid \case
                Left message -> redirectTo ShowChannelAction { channelId = message.channelId }
                Right message -> do
                    message <- message |> createRecord

                    let channelId = message.channelId
                    redirectTo ShowChannelAction { channelId }

    action DeleteMessageAction { messageId } = do
        message <- fetch messageId

        -- Only allow editing if the message is created by the current user
        accessDeniedUnless (message.userId == currentUserId)

        deleteRecord message
        redirectTo ShowChannelAction { channelId = message.channelId }
