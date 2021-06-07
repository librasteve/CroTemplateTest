use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Cro::TemplateTest::Routes;

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => %*ENV<CRO__TEMPLATETEST_HOST> ||
        die("Missing CRO__TEMPLATETEST_HOST in environment"),
    port => %*ENV<CRO__TEMPLATETEST_PORT> ||
        die("Missing CRO__TEMPLATETEST_PORT in environment"),
    application => routes(),
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at http://%*ENV<CRO__TEMPLATETEST_HOST>:%*ENV<CRO__TEMPLATETEST_PORT>";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
