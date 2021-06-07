use Cro::HTTP::Router;
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

        get -> 'cform' {
            my $context = $ws.context;
            template 'templates/cform.crotmp', $context;
        }
    }
}