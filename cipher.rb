# Encryption algorithm
def encrypt(e,n, message)
  encrypted = ""
  if message
    message.bytes.each do |ch|
      begin
        encrypted += ((ch**e)%n).to_s+"."
      rescue
      end
    end
  else
    encrypted = "No message"
  end
  encrypted
end

# Decryption algorithm
def decrypt(d, n, message)
  decrypted = ""
  if message
    message.split('.').each do |ch|
      begin
        decrypted += ((ch.to_i**d)%n).chr
      rescue
      end
    end
  else
    decrypted = "No message"
  end
  decrypted
end

def __main__
  public_key = File.open("./keys/public.key")
  public_keys = public_key.read.split(',').map(&:to_i)
  public_key.close

  private_key = File.open("./keys/private.key")
  private_keys = private_key.read.split(',').map(&:to_i)
  private_key.close

  print "Message: "
  message = gets.chomp
  encrypted = encrypt(*public_keys, message)
  decrypted = decrypt(*private_keys, encrypted)
  puts "Encrypted: #{encrypted}", "Decrypted: #{decrypted}"
end
# Uncomment to work from terminal
# __main__
