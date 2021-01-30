terraform {
  backend "s3" {
    bucket  = "ahyaemon-react-amplify-sample-tfstate"
    key     = "backend.tfstate"
    region  = "ap-northeast-1"
    profile = "amplify-tutorial"
  }
}
