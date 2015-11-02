require 'opal'
require 'browser/interval'
# require 'jquery'
# require 'opal-jquery'
require 'json'
require 'reactive-ruby'
  
Document.ready? do
  React.render(                                            
    React.create_element(
      Nodelist, url: "/nodes", poll_interval: 10), 
    Element['#content']
  )
end

class NodeBox

  include React::Component
  required_param :url
  required_param :poll_interval

  define_state nodes: JSON.new

  before_mount do
    @fetcher = every(poll_interval) do
      HTTP.get(url) do |response|
        if response.ok?               
          comments! JSON.parse(response.body)
        else
          puts "failed with status #{response.status_code}"
        end
      end
    end
  end

  after_mount do
    puts "start me up!"
    @fetcher.start
  end

  before_unmount do
    @fetcher.stop
  end

  def render
    div.nodes_box do
      h1 { "Nodes" }
      NodeList nodes: nodes
    end
    
  end

end

class NodeList
  include React::Component

  required_param :nodes, type: Array

  def render
    div.nodeList do
      nodes.each do |node|
        Node fqdn: node[:fqdn]
      end
    end
  end

end


class Node
  include React::Component

  required_param :fqdn

  def render
    div.node do
      h2.node_fqdn { fqdn }
    end
  end

end
