class Credentials
  USERNAME_KEY = 'MINT_USERNAME'
  PASSWORD_KEY = 'MINT_PASSWORD'

  VALIDATION_MESSAGE = <<-TEXT
Please assign #{USERNAME_KEY} and #{PASSWORD_KEY} in an .env file (see .env.example), then run:
  foreman run ruby mint-exporter.rb
TEXT

  def username
    "charlesmzhu@gmail.com"
  end

  def password
    "clownman2124"
  end

  # Exits and prints a message unless a username and password are present.
  def validate!
    return if username && password

    STDERR.puts(VALIDATION_MESSAGE)
    exit 1
  end
end