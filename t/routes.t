use Cro::HTTP::Test;
use Test;
use Cro::TemplateTest::Routes;

test-service routes, {
    test get('/'),
            status => 200,
            body-text => '<h1> Cro::TemplateTest </h1>';
}

done-testing;
