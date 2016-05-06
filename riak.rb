# sudo gem install riak-client
# https://github.com/basho/riak-ruby-client

# curl -s 127.0.0.1:32768/stats (8098 port)
# nodes (8087 port)

require 'riak'


client = Riak::Client.new(:nodes => [
  {:host => '127.0.0.1', :pb_port => 32769},
   {:host => '127.0.0.1', :pb_port => 32775},
    {:host => '127.0.0.1', :pb_port => 32773}
])
puts client.ping

# Retrieve a bucket
bucket = client.bucket("doc")  # a Riak::Bucket

# Get an object from the bucket
object = bucket.get_or_new("index.html")   # a Riak::RObject

# Change the object's data and save
object.raw_data = "<html><body>Hello, world!</body></html>"
object.content_type = "text/html"
object.store

# Reload an object you already have
o1 = object.reload                  # Works if you have the key and vclock, using conditional GET
object.reload :force => true   # Reloads whether you have the vclock or not

# Access more like a hash, client[bucket][key]
o2 = client['doc']['index.html']   # the Riak::RObject

# Create a new object
new_one = Riak::RObject.new(bucket, "application.js")
new_one.content_type = "application/javascript" # You must set the content type.
new_one.raw_data = "alert('Hello, World!')"
new_one.store

# Print
puts "o1"
puts o1.content_type
puts o1.raw_data

puts "o2"
puts o2.content_type
puts o2.raw_data

puts "o3"
puts new_one.reload.content_type
puts new_one.reload.raw_data