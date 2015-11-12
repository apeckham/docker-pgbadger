require 'aws-sdk'

ENV['DB_INSTANCE_IDENTIFIER'] or raise 'DB_INSTANCE_IDENTIFIER is required'
ENV['BUCKET'] or raise 'BUCKET is required'

rds = Aws::RDS::Client.new

files = rds.describe_db_log_files(db_instance_identifier: ENV['DB_INSTANCE_IDENTIFIER'])
files = files.to_h[:describe_db_log_files]

files.last(5).each do |file|
  open(File.basename(file[:log_file_name]), 'wb+') do |f|
    opts = {
      db_instance_identifier: ENV['DB_INSTANCE_IDENTIFIER'],
      log_file_name: file[:log_file_name],
      marker: "0"
    }

    while true do
      puts "download_db_log_file_portion #{file[:log_file_name]} #{opts[:marker]}"
      out = rds.download_db_log_file_portion(opts)
      f.write(out[:log_file_data])

      break if opts[:marker] == out[:marker]
      opts[:marker] = out[:marker]
    end
  end
end

system("pgbadger -p '%t:%r:%u@%d:[%p]:' postgresql.log.*") or raise 'pgbadger failed'

s3 = Aws::S3::Resource.new
obj = s3.bucket(ENV['BUCKET']).object("pgbadger-#{Date.today}.html")
obj.upload_file 'out.html', {acl: 'public-read'}