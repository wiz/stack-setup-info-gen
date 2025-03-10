module Stack.Setup.Info.Types where

import ClassyPrelude

-- e.g. 8.6.1-beta1
newtype GhcDisplayVersion = GhcDisplayVersion Text
  deriving (Eq, IsString, Ord, Show)
-- e.g. 8.6.0.20180101
newtype GhcVersion = GhcVersion Text
  deriving (Eq, IsString, Ord, Show)
newtype Arch = Arch Text
  deriving (Eq, IsString, Ord, Show)
newtype Url = Url Text
  deriving (Eq, IsString, Ord, Show)
newtype Sha256Sum = Sha256Sum Text
  deriving (Eq, IsString, Ord, Show)
newtype Sha1Sum = Sha1Sum Text
  deriving (Eq, IsString, Ord, Show)
newtype RelativePath = RelativePath Text
  deriving (Eq, IsString, Ord, Show)
newtype FileName = FileName Text
  deriving (Eq, IsString, Ord, Show)
newtype SystemName = SystemName Text
  deriving (Eq, IsString, Ord, Show)
newtype ContentLength = ContentLength Int
  deriving (Eq, Ord, Show)
newtype ShaFile = ShaFile Text
  deriving (IsString)

urlCorrection :: Url -> Url
urlCorrection "https://downloads.haskell.org/~ghc/8.6.2/ghc-8.6.2-x86_64-darwin.tar.xz"
  = "https://downloads.haskell.org/~ghc/8.6.2/ghc-8.6.2-x86_64-apple-darwin.tar.xz"
urlCorrection a = a

baseBaseUrl :: Text
baseBaseUrl = "https://downloads.haskell.org/~ghc/"

toUrl :: GhcDisplayVersion -> RelativePath -> Url
toUrl gdv rp = urlCorrection $ toUrl' gdv rp

toUrl' :: GhcDisplayVersion -> RelativePath -> Url
toUrl' (GhcDisplayVersion ghcDisplayVersion) (RelativePath relPathText) = Url $
  baseBaseUrl <> ghcDisplayVersion <> "/" <> dropPrefixLength "./" relPathText

-- like stripPrefix, but without enforcing that it is actually a prefix
dropPrefixLength :: Text -> Text -> Text
dropPrefixLength prefix t = drop (length prefix) t

dropSuffixLength :: Text -> Text -> Text
dropSuffixLength suffix = reverse . dropPrefixLength suffix . reverse

tfail :: Text -> IO a
tfail = fail . unpack
