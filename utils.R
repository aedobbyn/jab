twitter.twitter_auth <- function() {
  if (exists("twitter_token")) {
    return(invisible())
  }
  
  TWITTER_APP_NAME <- Sys.getenv("TWITTER_APP_NAME")
  TWITTER_API_KEY <- Sys.getenv("TWITTER_API_KEY")
  TWITTER_API_SECRET <- Sys.getenv("TWITTER_API_SECRET")
  TWITTER_ACCESS_TOKEN <- Sys.getenv("TWITTER_ACCESS_TOKEN")
  TWITTER_ACCESS_TOKEN_SECRET <- Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
  
  # Create token and store in global env
  twitter_token <<- rtweet::create_token(
    app = TWITTER_APP_NAME,
    consumer_key = TWITTER_API_KEY,
    consumer_secret = TWITTER_API_SECRET,
    access_token = TWITTER_ACCESS_TOKEN,
    access_secret = TWITTER_ACCESS_TOKEN_SECRET,
    set_renv = TRUE # Sets PAT before we move it https://github.com/ropensci/rtweet/blob/37f0b804436dad8634362e6a2012af9254b9c505/R/tokens.R#L222
  )
  
  # Move token to temp now that PAT has been set
  token_file_name <- ".rtweet_token.rds"
  original_token_path <- "~/.rtweet_token.rds"
  
  if (fs::file_exists(original_token_path)) {
    new_dir <- fs.temp_directory_create()
    
    dev.glue_message("Saving token to {new_dir}.")
    fs::file_move(original_token_path, new_dir)
  } else {
    message("Error saving token.")
  }
  
  message("Twitter auth using token complete.")
}