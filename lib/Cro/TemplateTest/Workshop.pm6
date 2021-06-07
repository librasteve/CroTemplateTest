say "Initializing Workshop";

class Context {
    has $.action = 'mailto:p6steve.com';
    has $.cf-name = 'p6steve';
    has $.cf-email = 'me@p6steve.com';
    has $.cf-subject = 'Raku does HTML';
    has $.cf-message = 'Describe your feelings about this...';
}
class Workshop {
    method context() {
        Context.new;
    }
    method init() {
        self.init-qform;
        self.init-cform;
    }
    method init-cform() {
        spurt "templates/cform.crotmp", "<h1>yo</h1>";
    }
    method init-qform() {
        ##say dir "templates/";

        #slightly tweaked example of gfldex Low profile quoting post
        #viz. https://gfldex.wordpress.com/2021/06/01/low-profile-quoting/
        #viz. https://p6steve.wordpress.com/2021/06/04/414/
        #in Comma IDE set ⌘, - editor - color scheme - raku - bad syntax OFF
        
        constant term:<§> = class :: does Associative {
            sub qh($s) {
                $s.trans([ '<'   , '>'   , '&' ] =>
                        [ '&lt;', '&gt;', '&amp;' ])
            }
            sub et($k) {
                my @empty-tags = <area base br col hr img input link meta param command keygen source>;
                ' /' if $k ~~ @empty-tags.any
            }
            sub qa(%_) {
                %_.map({
                    if .value ~~ Bool && True { .key }
                    else {.key ~ '="' ~ .value ~ '"' }
                }).join(' ')
            }

            role NON-QUOTE {}

            method AT-KEY($key) {
                when $key ~~ /^ '&' / {
                    $key does NON-QUOTE
                }
                when $key ~~ /\w+/ {
                    sub (*@a, *%_) {
                        (
                        '<' ~ $key ~ (+%_ ?? ' ' !! '')
                            ~ qa(%_) ~ et($key) ~ '>'
                            ~ @a.map({ $^a ~~ NON-QUOTE ?? $^a !! $^a.&qh }).join('')
                            ~ ( et($key) ?? '' !! '</' ~ $key ~ '>' )
                        ) does NON-QUOTE
                    }
                }
                #`[  #iamerejh
                when $value ~~ /^ <[.?!$@:&|]>/ {
                    $key does NON-QUOTE
                }
                #]
            }
        }

        sub pretty-print-html(Str $html is rw --> Str) {
            $html ~~ s:g/'<' <!before \/>/$?NL\</;
            $html ~~ s:g/'><'/\>$?NL\</;
            return '<!DOCTYPE html>' ~ $html;
        }

        my $css = q:to/END/;
        #demoFont {
        font-size: 16px;
        color: #ff0000;
        }
        END

        my $action = 'mailto:me@p6steve.com';
        my $cf-name = 'p6steve';
        my $cf-email = 'me@p6steve.com';
        my $cf-subject = 'Raku does HTML';
        my $cf-message = 'Describe your feelings about this...';

        my $size = <40>;
        my $pattern = <[a-zA-Z0-9 ]+>;
        
        my $html = §<html>(§<head>(§<title>()),
            §<style>(:type<text/css>, $css),
            §<body>(
                §<form>(:action<.action>, :method<post>,
                    §<p>('Your Name (required)'),
                    §<input>(:type<text>, :required, :name<cf-name>, :value($cf-name), :$size, :$pattern,),

                    §<p>('Your Email (required)'),
                    §<input>(:type<email>, :required, :name<cf-email>, :value($cf-email), :$size,),  #email type validates input

                    §<p>('Your Subject (required)'),
                    §<input>(:type<text>, :required, :name<cf-subject>, :value($cf-subject), :$size, :$pattern,),

                    §<p>(:id<demoFont>, 'Your Message (required)'),
                    §<p>(§<textarea>(:rows<10>, :cols<35>, :required, :name<cf-message>, $cf-message, ),),

                    §<input>(:type<submit>, :name<cf-submitted>, :value<Send>,),
                )
            )
        );
        
        spurt "templates/qform.crotmp", pretty-print-html($html);
    }
}