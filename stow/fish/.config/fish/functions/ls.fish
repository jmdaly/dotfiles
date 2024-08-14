if type -q lsd
  function ls --wraps=lsd --description 'alias ls=lsd'
    lsd $argv
  end
end
