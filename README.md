# BitAttrs

BitAttrs allows to store a set of boolean values in one field.

* Simple and easy to use
* Has no additional dependencies, like ActiveRecord
* Works well with ActiveRecord, DataMapper, Virtus or POROs
* Has convenient search scopes for ActiveRecord and DataMapper

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bit_attrs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bit_attrs

## Usage

BitAttrs has similar to Rails 4 enums syntax:

````ruby
class User < ActiveRecord::Base
  include BitAttrs
  bitset roles: [:admin, :user, :guest]
end
```

In this case, BitAttrs will expect ```roles_mask``` field to actually save roles in:

```ruby
#<User id: 1, name: 'test user', email: "test@gmail.com", roles_mask: 2>
```

You can freely add new attributes to the end of the list without changing already existing records:

````ruby
class User < ActiveRecord::Base
  include BitAttrs
  bitset roles: [:admin, :user, :guest, :developer]
end
```

Similarly to Rails enums, if you want to delete some of the attributes, you might want to use hash syntax, where keys are attribute names and values are indexes:

````ruby
class User < ActiveRecord::Base
  include BitAttrs
  bitset roles: { admin: 0, user: 1, developer: 3 }
end
```

Attributes can be accessed on the instance level or through the ```roles``` method:

```ruby
> user
=> #<User id: 1, name: 'test user', email: "test@gmail.com", roles_mask: 2>

> user.user?
=> true

> user.roles
=> { admin: false, user: true, guest: false }
```

Update all attributes (with overwriting):

```ruby
> user.roles
=> { admin: false, user: true, guest: false }

> user.update(roles: { guest: true }) && user.roles
=> { admin: false, user: false, guest: true }
```

Update single attribute:

```ruby
> user.roles
=> { admin: false, user: true, guest: false }

> user.admin = true
=> { admin: true, user: true, guest: false }
```

### Scopes

Considering the example above, BitAttrs will create following search scopes:

```
* User.with_roles
* User.without_roles
```

Example:

```ruby
> User.with_roles(:user)
=> all users which have role :user set to true
> User.with_roles(:admin, :user).without_roles(:developer)
=> all users which have following roles set: { admin: true, user: true, developer: false }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rsamoilov/bit_attrs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
