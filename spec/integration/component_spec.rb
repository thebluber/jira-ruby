require 'spec_helper'

describe Jira::Resource::Component do


  let(:client) do
    client = Jira::Client.new('foo', 'bar')
    client.set_access_token('abc', '123')
    client
  end

  let(:expected_attributes) do
    {
      'self' => "http://localhost:2990/jira/rest/api/2/component/10000",
      'id'   => "10000",
      'name' => "Cheesecake"
    }
  end

  before(:each) do
    stub_request(:get,
                 "http://localhost:2990/jira/rest/api/2/component/10000").
                 to_return(:body => get_mock_response('component/10000.json'))
    stub_request(:delete,
                 "http://localhost:2990/jira/rest/api/2/component/10000").
                 to_return(:body => nil)
    stub_request(:post,
                 "http://localhost:2990/jira/rest/api/2/component").
                 to_return(:status => 201, :body => get_mock_response('component.post.json'))
    stub_request(:put,
                 "http://localhost:2990/jira/rest/api/2/component/10000").
                 to_return(:status => 200, :body => get_mock_response('component/10000.put.json'))
  end

  it "should get a single component by id" do
    component = client.Component.find(10000)

    component.should have_attributes(expected_attributes)
  end

  it "builds and fetches single component" do
    component = client.Component.build('id' => 10000)
    component.fetch

    component.should have_attributes(expected_attributes)
  end

  it "deletes a component" do
    component = client.Component.build('id' => "10000")
    component.delete.should be_true
  end

  it "saves a new component" do
    component = client.Component.build({"name" => "Test component", "project" => "SAMPLEPROJECT"})
    component.save.should be_true
    component.id.should   == "10001"
    component.name.should == "Test component"
  end

  it "saves an existing component" do
    component = client.Component.build('id' => '10000')
    component.fetch
    component.attrs['name'] = "Jammy"
    component.save.should be_true
    component.id.should == "10000"
    component.name.should == "Jammy"
  end

end
