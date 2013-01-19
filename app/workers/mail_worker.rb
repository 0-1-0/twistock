class MailWorker
  include Sidekiq::Worker
  

  def self.buy_message(transaction)
    if transaction.owner.has_email?
      MailWorker.perform_async(transaction.owner.id, transaction.message)
    end
  end


  def self.sell_message(transaction)
    if transaction.owner.has_email?
      MailWorker.perform_async(transaction.owner.id, transaction.message)
    end
  end


  def perform(id, message)

    user = User.find(id)


    Pony.mail(
      from: "info@twistock.com",
      to: user.email,
      subject: "A message from the Twistock website",
      body: message,
      port: '587',
      via: :smtp,
      via_options: { 
        :address              => 'smtp.sendgrid.net', 
        :port                 => '587', 
        :enable_starttls_auto => true, 
        :user_name            => ENV['SENDGRID_USERNAME'], 
        :password             => ENV['SENDGRID_PASSWORD'], 
        :authentication       => :plain, 
        :domain               => 'heroku.com'
      })
      

  end


end
