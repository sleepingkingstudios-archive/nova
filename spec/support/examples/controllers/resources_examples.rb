# spec/support/examples/controllers/resources_examples.rb

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

        shared_examples 'assigns directories' do
          it 'assigns the directories to @directories' do
            perform_action

            expect(assigns :directories).to be == directories
            expect(assigns :current_directory).to be == directories.last
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

        shared_examples 'requires authentication' do |authenticate_root: true|
          before(:each) { sign_out :user }

          if authenticate_root
            describe 'with an empty path', :path => :empty do
              it 'redirects to root' do
                perform_action

                expect(response.status).to be == 302
                expect(response).to redirect_to root_path

                expect(request.flash[:warning]).not_to be_blank
              end # it
            end # describe
          end # if

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
      end # module
    end # module
  end # module
end # module
