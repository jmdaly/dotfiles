if status is-interactive 
  if type -q bat
    function cat --wraps=bat --description 'alias cat=bat'
      bat $argv
    end
  end
end
