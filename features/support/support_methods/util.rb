# frozen_string_literal: true

def safe_visit url
  visit url
rescue Exception => e 
  p "An error occured while visiting: #{e}"
  visit url  
end

def send_payment_ok
  Pony.mail(
      to: 'qa@inveon.com',
      via: :smtp,
      body: 'DEAR ME PAYMENT OK',
      subject: 'DEAR ME PAYMENT OK',
      attachments: { "logs.csv" => File.read('logs.csv')  },
      via_options: {
          address: 'smtp.gmail.com',
          port: '587',
          enable_starttls_auto: true,
          user_name: 'kaan.cakmak@inveon.com',
          password: 'roysyliczrdhpmco',
          autentication: :plain
      }
    )
end

def send_alert_mail
  Pony.mail(
      to: 'qa@inveon.com',
      via: :smtp,
      body: 'DEAR ME - AN ERROR OCCURED IN PAYMENT STEP',
      subject: 'DEAR ME PAYMENT STEP FAILED',
      attachments: { "javascript_error_logs.csv" => File.read('logs.csv') },
      via_options: {
          address: 'smtp.gmail.com',
          port: '587',
          enable_starttls_auto: true,
          user_name: 'kaan.cakmak@inveon.com',
          password: 'roysyliczrdhpmco',
          autentication: :plain
      }
    )
end

def send_severe_logs
  Pony.mail(
      to: 'qa@inveon.com',
      via: :smtp,
      body: "DEAR ME - JAVASCRIPT SEVERE LOGS",
      subject: 'JAVASCRIPT ERROR DEAR ME',
      attachments: { "javascript_error_logs.csv" => File.read('logs.csv') },
      via_options: {
          address: 'smtp.gmail.com',
          port: '587',
          enable_starttls_auto: true,
          user_name: 'kaan.cakmak@inveon.com',
          password: 'roysyliczrdhpmco',
          autentication: :plain
      }
    )
end

def write_logs_to_file(arg)
  File.write('logs.csv', "#{arg}\n", mode: 'a')
end
