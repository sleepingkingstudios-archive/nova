# spec/support/examples/controllers/resources_examples.rb

require 'support/contexts/controllers/resources_contexts'
require 'support/examples/controllers/rendering_examples'

module Spec
  module Examples
    module Controllers
      module ResourcesExamples
        include Rails.application.routes.url_helpers

        include Spec::Contexts::Controllers::ResourcesContexts
        
        include Spec::Examples::Controllers::RenderingExamples

        def default_url_options(options = {})
          defined?(super) ? super(options) : options
        end # method default_url_options

        shared_examples 'assigns new directory' do
          it 'assigns the directory to @directory' do
            perform_action

            expect(assigns :directory).to be_a Directory
            expect(assigns(:directory).parent).to be == directories.last
          end # it
        end # shared_examples

        shared_examples 'assigns directories' do
          it 'assigns the directories to @directories' do
            perform_action

            expect(assigns :directories).to be == directories
            expect(assigns :current_directory).to be == directories.last
          end # it
        end # shared_examples

        shared_examples 'assigns the resource' do
          it 'assigns the resource to @resource' do
            perform_action

            expect(assigns :resource).to be == resource
          end # it
        end # shared_examples

        shared_examples 'redirects to the last found directory' do
          it 'redirects to the last found directory' do
            perform_action

            expect(response.status).to be == 302
            expect(response).to redirect_to directory_path(assigns(:directories).last)

            expect(request.flash[:warning]).not_to be_blank
          end # it
        end # shared_examples

        shared_examples 'redirects to the last found directory dashboard' do
          it 'redirects to the last found directory dashboard' do
            perform_action

            expect(response.status).to be == 302
            expect(response).to redirect_to dashboard_directory_path(assigns(:directories).last)

            expect(request.flash[:warning]).not_to be_blank
          end # it
        end # shared_examples

        shared_examples 'requires authentication' do
          before(:each) { sign_out :user }

          describe 'with an invalid path', :path => :invalid_directory do
            it 'redirects to the last found directory' do
              perform_action

              expect(response.status).to be == 302
              expect(response).to redirect_to directory_path(assigns(:directories).last)

              expect(request.flash[:warning]).not_to be_blank
            end # it
          end # describe

          describe 'with a valid path', :path => :valid_directory do
            it 'redirects to the last found directory' do
              perform_action

              expect(response.status).to be == 302
              expect(response).to redirect_to directory_path(assigns(:directories).last)

              expect(request.flash[:warning]).not_to be_blank
            end # it
          end # describe
        end # shared_examples

        shared_examples 'requires authentication for root directory' do
          before(:each) { sign_out :user }

          describe 'with an empty path', :path => :empty do
            it 'redirects to root' do
              perform_action

              expect(response.status).to be == 302
              expect(response).to redirect_to root_path

              expect(request.flash[:warning]).not_to be_blank
            end # it
          end # describe
        end # shared_examples
      end # module
    end # module
  end # module
end # module
