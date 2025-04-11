function firefox-harden --description "Download and install the arkenfox firefox hardening & cleanup scripts"
    set --local ff_dir '/Users/roee/Library/Application Support/Firefox'
    set --local ff_profile_dirs (grep '^Path=' $ff_dir/profiles.ini | sed 's/^Path=//')

    for profile_dir in $ff_dir/$ff_profile_dirs
        if test -d $profile_dir
            echo "Downloading the updater script into `$profile_dir`..."
            curl --no-progress-meter 'https://raw.githubusercontent.com/arkenfox/user.js/master/updater.sh' --output $profile_dir/updater.sh
            echo "Downloading the user overrides config into `$profile_dir`..."
            curl --no-progress-meter 'https://raw.githubusercontent.com/5c077m4n/dotconfig/master/assets/firefox/user-overrides.js' --output $profile_dir/user-overrides.js
            echo "Downloading the prefs cleaner script into `$profile_dir`..."
            curl --no-progress-meter 'https://raw.githubusercontent.com/arkenfox/user.js/master/prefsCleaner.sh' --output $profile_dir/prefs-cleaner.sh

            killall firefox

            sh $profile_dir/updater.sh -u
            sh $profile_dir/prefs-cleaner.sh

            echo ---
            echo "Hardened Firefox profile `$(basename $profile_dir)` successfully! 💪🥳"
            echo ---
        end
    end
end
