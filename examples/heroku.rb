# Example babushka deps for setting up a heroku like development environment.
# 
#  Add this file to your applications babushka-deps director and run babushka from the root directory.

# ### heroku-dev
# A top level dependency. Doesn't do anything, just requires all of the other deps.
# Installs rvm, ruby 1.9.2, memcached and postgresql.
# Creates a gemset for the project.
#
# Run with:
#     babushka heroku-dev
dep 'heroku-dev' do
  requires 'rvm',
           'ruby-1.9.2 installed',
           'gemset ruby-1.9.2-p180@heroku'
           'memcached.managed',
           'postgresql.managed'
end

# ### Managed dependencies. 
#
# Uses the .managed meta dependency that comes with babushka.
#
# Memcached and Postgresql will be installed using your locally available 
# package management tool: homebrew, apt, yum and pacman.
dep 'memcached.managed'
dep 'postgresql.managed'

# ### gemset ruby-1.9.2-p180@heroku
#
# Note as this dep ends in  it inherits from the :rvm meta dependency defined above.
dep 'gemset ruby-1.9.2-p180@heroku' do
  requires 'rvm', 
           'ruby-1.9.2 installed'

 # Consider this dependency met if the output of _rvm info_ contains the string _"ruby-1.9.2-p180@heroku"_.  
  met? { 
    shell('rvm info')['ruby-1.9.2-p180@heroku']
  } 
  
  # To meet this dependency run _'rvm --create use  "ruby-1.9.2-p180@heroku"'_.
  meet { 
    shell('rvm --create use  "ruby-1.9.2-p180@heroku"') 
  }
  
end

# ### Install Ruby 1.9.2
dep 'ruby-1.9.2 installed' do
  requires 'rvm'
  
  # Consider this dependency met if the output of _rvm list_ contains the string _"ruby-1.9.2-p180"_.  
  met? { 
    shell('rvm list')['ruby-1.9.2-p180'] 
  }
  
  # To meet this dependency run _'rvm install ruby-1.9.2-p180'_.
  meet { 
    # Prints _"rvm install ruby-1.9.2-p180"_ and opens a level of indentation in the
    # babushka console output.
    log("rvm install ruby-1.9.2-p180") { 
      shell('rvm install ruby-1.9.2-p180') 
    } 
  }
  
end

# ### Install Ruby Version Manager
dep 'rvm' do
  
  # Consider this dependency met if the output of _rvm -v_ contains the string _"rvm"_.  
  met? { 
    login_shell('rvm -v')['rvm']
  }
  
  # To meet this dependency install rvm.
  meet {
    # Stop babushka and wait for the user to choose to install rvm system-wide or not.
    # Default to installing locally.
    if confirm("Install rvm system-wide?", :default => 'n')
      # Use log_shell to print _"Installing rvm using rvm-install-system-wide"_ and then 
      # run _'bash < <( curl -L http://bit.ly/rvm-install-system-wide )'_ to install rvm
      # sytem wide.
      log_shell("Installing rvm using rvm-install-system-wide", 
                'bash < <( curl -L http://bit.ly/rvm-install-system-wide )')
      
      
    # Otherwise use log_shell to print _"Installing rvm using rvm-install-system-wide"_ and then 
    # run _'bash -c "`curl http://rvm.beginrescueend.com/releases/rvm-install-head`"'_ 
    # to install rvm for the local user.
    else
      log_shell("Installing rvm using rvm-install-head", 
                'bash -c "`curl http://rvm.beginrescueend.com/releases/rvm-install-head`"')
      
    end
  }
  
end