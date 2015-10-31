require 'opal'
require 'browser/interval'
require 'jquery'
require 'opal-jquery'
require 'json'
require 'reactive-ruby'
  
Document.ready? do
    React.render(                                            
      React.create_element(
        CommentBox, url: "comments.json", poll_interval: 2), 
      Element['#content']
    )
end



