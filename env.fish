if set -q argv[1]
    set build $argv[1]
else
    set -x build "build"
end

set -x LOGTALKUSER (pwd)/$build/_deps/logtalk-src/
set -x LOGTALKHOME (pwd)/$build/_deps/logtalk-src/
set -x PATH (pwd)/$build/swipl/bin:$LOGTALKHOME/integration:$PATH

alias swilgt "swipl -s $LOGTALKHOME/integration/logtalk_swi.pl"
