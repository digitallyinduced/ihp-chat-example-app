module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types
import IHP.LoginSupport.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
    newSessionUrl _ = "/Channels"

type instance CurrentUserRecord = User

data SessionsController
    = NewSessionAction
    | CreateSessionAction
    | DeleteSessionAction
    deriving (Eq, Show, Data)

data ChannelsController
    = ChannelsAction
    | NewChannelAction
    | ShowChannelAction { channelId :: !(Id Channel) }
    | CreateChannelAction
    | EditChannelAction { channelId :: !(Id Channel) }
    | UpdateChannelAction { channelId :: !(Id Channel) }
    | DeleteChannelAction { channelId :: !(Id Channel) }
    deriving (Eq, Show, Data)

data MessagesController
    = CreateMessageAction
    | EditMessageAction { messageId :: !(Id Message) }
    | UpdateMessageAction { messageId :: !(Id Message) }
    | DeleteMessageAction { messageId :: !(Id Message) }
    deriving (Eq, Show, Data)

data UsersController
    = NewUserAction
    | CreateUserAction
    deriving (Eq, Show, Data)
