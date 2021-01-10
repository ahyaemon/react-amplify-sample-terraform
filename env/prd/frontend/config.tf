terraform {
  backend "s3" {
    bucket  = "ahyaemon-react-amplify-sample-tfstate"
    key     = "frontend.tfstate"
    region  = "ap-northeast-1"
    profile = "amplify-tutorial"
  }
}
