1. rake notes:todo, :fixme, :optimize
  rake notes:custom ANNOTATION=DANE

2. rails console production/test/development

3. rails c --sandbox
  Wraps your session in a transaction and rolls it back on transaction

4. rails s thin
  Include thin webserver gem, then use the server name in your command

5. rails g resource user:references name email token:string{6} bio:text
    references- adds id, and belongs_to in model
  rails g resource user name:index email:uniq 
    sets indexes

6. rake db:migrate:status
shows the status of your migrations

7. User.pluck(:email)
  Iterates and maps for a field
  User.uniq.pluck(:status)

8. Mergin nested hashes
{ :nested => { :one => 1}}.merge(:nested => {:two => 2})
overrides original hash
{ :nested => { :one => 1}}.deep_merge(:nested => { :two => 2})

9. Remove specific keys from hash (handy for params)
params.except(:controller, :action)

10. Use reverse merge for defaults
merge will replace
{required: true, optional:false}.reverse_merge(optional:true)
will merge if its not in there

11. Inquire a string
"magic".inquiry.magic?
You could add a method missing to use this for statuses

12. Custom form builders
config.action_view.default_form_builder = MyFormBuilder
config.action_view.field_error_proc = ->(field, _) {field}

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
 errors = Array(instance.error_message).join(',')
 %(#{html_tag}<span class="validation-error">&nbsp;#{errors}</span>).html_safe
end

removes automatic wrapping of error fields with divs

13. Route errors to a controller
You can route errors to any rack application (anything that supports a call). The rails router is a rack application.

config.exceptions_app = routes
match "/404", :to => "errors#not_found"

14. Use .find_each instead of .all.each

15. Run in a background thread
class Blah
  require 'thread'

  def self.queue
    @queue || Queue.new #set up your queue, threadsafe
  end

  def self.thread
    @thread || Thread.new do
      while job = queue.pop
        job.call
      end
    end
  end

  thread #start the thread as rails loads

  def add_load_video
    self.class.queue << -> { load_video }
  end
end

16. Fibonacci using Enumerator
An enumerator can be created with Enumerator.new &block. The block has to have a single parameter, called yielder by convention, that will yield up a value when the enumerator iterates. The body of the block determines what it yields. Here’s an example: this creates an enumerator that backs the natural numbers.

  fib = Enumerator.new do |yielder|
    a = b = 1
    loop do
      yielder << a #yielder.yield
      a, b = b, a + b
    end
  end

  fib.take(10)

17. Route constraints
  Verb constraints
  match 'photos/show' => 'photos#show', :via => :get

  Segment constraints
  match 'photos/:id' => 'photos#show', :id => /[A-Z]\d{5}/  #matches /photos/A12345

  Request based constraints
  match 'photos', :constraints => { :subdomain => "admin" }

  Advanced constraints
  create a class that defines matches?(request) and returns true or false
  match "photos", :constraints => AdminUserConstraint.new

18. Redirect using routes
  match '/stories' => redirect("/posts")

19. Translate paths
  scope :path_names => { :new => "neu", :edit => "bearbeiten" } do
    resources :categories, :path => "kategorien"
  end

20. Override singular form
Add additional rules to Inflector

  ActiveSupport::Inflector.inflections do |inflect|
    inflect.irregular 'tooth', 'teeth'
  end

21. Restrict rake routes
  rake routes CONTROLLER=users

22. Migrations
  remove_column :stock_levels, :order_id if column_exists?(:stock_levels, :order_id)
  table_exists?(:stock_levels)

23. rake db:migrate:redo
  rollback and runs migration again

24. When two migrations both update the data and new columns are validated in model
undefined method error

class AddFlagToProduct < ActiveRecord::Migration
  class Product < ActiveRecord::Base #create a faux model so that validations aren't run
  end
     
  def change
    add_column :products, :flag, :integer
    Product.reset_column_information #refresh ActiveRecord cache
    Product.all.each do |product|
      product.update_attributes!(:flag => false)
    end
  end
end

25. Conditional validations
  validates :surname, :presence => true, :if => :surname_entered
                                       , :if => "surname.present?"
                                       , :unless => Proc.new { |a| a.password.blank? }

26. Reloading controller cache
  customer.orders
  customer.orders.size #now cached
  customer.orders(true).size

27. Running EXPLAIN
User.where(:id => 1).joins(:posts).explain

#Automatic explain if query exceeds threshold
config.active_record.auto_explain_threshold_in_seconds

28. Instead of using locals when passing to a partial
 render :partial => "customer", :object => @new_customer
 render @customer #will look for a partial _customer.html.haml

29. Skipping before filters
  handy to have in ApplicationController
  before_filter :validates_user

  in UserSessionController
  skip_before_filter :validate_user

30. Around filters
Submit to a block using yield
Good for logging or transactions

31. Register MIME types in initializer and use respond_to do |format| for RESTful downloads
Mime::Type.register "application/pdf", :pdf

32. Use .blank? and .present?
nil and false
empty strings
empty arrays and hashes
any other objects that respons to .empty?

33. .try method
like send but returns nil on nil object
@logger.try(:debug)

34. Aliasing
  alias_method :old_method, :method
  alias_attribute :login, :email

35. Delegate to law of demeter
has_one :profile

def name
  profile.name
end

delegate :name, :to => :profile

36. extend vs include
  extend for class methods
  include for instance methods

37. Active Support String Inflections
  pluralize
  singularize
  camelize
  underscore
  titleize
  humanize
  dasherize
  demodulize
  deconstantize

38. .kilobytes, megabytes, exabytes

39. .to_sentence
[Earth]
[Earth Wind]
[Earth Wind Fire]

40. (Date.today..Date.tomorrow).to_s(:db)

41. Performance tests
rails g performance_test homepage

require 'test_helper'
require 'rails/performance_test_help'
 
class HomepageTest < ActionDispatch::PerformanceTest
 # Replace this with your real tests.
 def test_homepage
  get '/'
 end
end

rake test:benchmark
rake test:profile

42. rails db, rails dbconsole

43. rails runner, rails r
runs ruby code in the context of rails non-interactively

44. rake about

45. rake stats

46. Using blocks
  def do_something
    with_logging('load') { @doc = Document.load('resume.txt') }

    #Do something
    
    with_logging('save') { @doc.save}
  end

  def with_logging(description)
    begin
      @logger.debug "Starting #{description}"
      yield
      @logger.debug "Completed #{description}"
    rescue
      @logger.error "#{description} failed!"
    end
  end

47. rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

48. Self modifying classes
classes are scripts, all executed

class User
  def save(login, password)
    encrypted_password = encrypt(password)
    #save
  end

  if ENCRYPTION_ENABLED
    def encrypt(string)
      #encrypt string
    end
  else
    def encrypt(string)
      string
    end
  end
end

49. load(_FILE_) reloads current class

50. BasicObject class
is the parent class of all classes in Ruby. Its an explicit blank class so no methods like puts or to_s
