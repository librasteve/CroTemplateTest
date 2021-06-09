use Cro::HTTP::Router;
use Cro::WebApp::Form;
use Cro::WebApp::Template;
use Cro::TemplateTest::Workshop;

my Workshop $ws = Workshop.new;
$ws.init;

sub routes() is export {
    route {
        get -> {
            content 'text/html', "<h1> Cro::TemplateTest </h1>";
        }

        get -> 'greet', $name {
            template 'templates/greet.crotmp', { :$name }
        }

        get -> 'qform' {
            my $context = $ws.context;
            template 'templates/qform.crotmp', $context;
        }

        # Render an empty form first
        get -> 'cform' {
            template 'templates/cform.crotmp', { form => Review.empty }
        }
        # When it is submitted, validate it, and render it again with validation
        # errors if there are problems. Otherwise, accept the review.
        post -> 'cform' {
            form-data -> Review $form {
                if $form.is-valid {
                    note "Got form data: $form.raku()";
                    content 'text/plain', 'Thanks for your review!';
                }
                else {
                    template 'templates/cform.crotmp', { :$form }
                }
            }
        }
    }
}
