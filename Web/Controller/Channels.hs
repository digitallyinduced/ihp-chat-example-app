module Web.Controller.Channels where

import Web.Controller.Prelude
import Web.View.Channels.Index
import Web.View.Channels.New
import Web.View.Channels.Edit
import Web.View.Channels.Show

instance Controller ChannelsController where
    beforeAction = ensureIsUser

    action ChannelsAction = do
        firstChannel <- query @Channel
                |> fetchOneOrNothing

        case firstChannel of
            Just channel -> redirectTo ShowChannelAction { channelId = channel.id }
            Nothing -> do
                -- No channel created yet, let's create a main channel
                channel <- newRecord @Channel
                        |> set #name "main"
                        |> createRecord

                redirectTo ShowChannelAction { channelId = channel.id }

    action NewChannelAction = do
        let channel = newRecord
        render NewView { .. }

    action ShowChannelAction { channelId } = autoRefresh do
        channel <- fetch channelId
            >>= pure . modify #messages (orderByDesc #createdAt)
            >>= fetchRelated #messages
        users <- query @User
            |> filterWhereIn (#id, map (get #userId) channel.messages)
            |> fetch
        channels <- query @Channel
            |> orderBy #createdAt
            |> fetch
        render ShowView { .. }

    action EditChannelAction { channelId } = do
        channel <- fetch channelId
        render EditView { .. }

    action UpdateChannelAction { channelId } = do
        channel <- fetch channelId
        channel
            |> buildChannel
            |> ifValid \case
                Left channel -> render EditView { .. }
                Right channel -> do
                    channel <- channel |> updateRecord
                    setSuccessMessage "Channel updated"
                    redirectTo EditChannelAction { .. }

    action CreateChannelAction = do
        let channel = newRecord @Channel
        channel
            |> buildChannel
            |> ifValid \case
                Left channel -> render NewView { .. }
                Right channel -> do
                    channel <- channel |> createRecord

                    -- Create a first message
                    newRecord @Message
                        |> set #userId currentUserId
                        |> set #channelId channel.id
                        |> set #body ("created the " <> channel.name <> " channel")
                        |> createRecord

                    redirectTo ShowChannelAction { channelId = channel.id }

    action DeleteChannelAction { channelId } = do
        channel <- fetch channelId
        deleteRecord channel
        setSuccessMessage "Channel deleted"
        redirectTo ChannelsAction

buildChannel channel = channel
    |> fill @'["name"]
    |> validateField #name nonEmpty
