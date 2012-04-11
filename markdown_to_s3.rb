#!/usr/bin/env ruby

require 'rdiscount'
require 'aws/s3'
require 'yaml'

bucket = ARGV[1]
output_name = ARGV[2]

amazon = YAML.load_file 'amazon_credentials.yml'

raw_markdown = File.open(ARGV[0]).map { |line| line }.join()
formatted_markdown = RDiscount.new(raw_markdown).to_html

AWS::S3::Base.establish_connection!(
  :access_key_id     => amazon['credentials']['access'],
  :secret_access_key => amazon['credentials']['secret']
)

AWS::S3::S3Object.store(
  output_name,
  formatted_markdown,
  bucket,
  :content_type => 'application/octet-stream'
)
