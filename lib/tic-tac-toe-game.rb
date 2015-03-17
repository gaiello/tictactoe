class TicTacToe

  def initialize
    #all possible wins
    @columns = [      
      [:a1,:a2,:a3],
      [:b1,:b2,:b3],
      [:c1,:c2,:c3],
      
      [:a1,:b1,:c1],
      [:a2,:b2,:c2],
      [:a3,:b3,:c3],
      
      [:a1,:b2,:c3],
      [:c1,:b2,:a3]
    ]
    
    @computer = rand() > 0.5 ? 'X' : 'O'
    @user = @computer == 'X' ? 'O' : 'X'
    
    @computer_name = "Computer"
    put_line
    puts "\n  TIC TAC TOE"
    print "\n What is your name? "
    STDOUT.flush
    @user_name = gets.chomp
    print "\n Do you want X or O? "
    STDOUT.flush
    @x_o = gets.chomp
    put_bar

    @user_score = 0
    @computer_score = 0
    
    start_game(@user == @x_o)
  end

  def start_game(user_goes_first)
    #Setting up Tic Tac Toe slots
    @places = {
      a1:" ",a2:" ",a3:" ",
      b1:" ",b2:" ",b3:" ",
      c1:" ",c2:" ",c3:" "
    }

    if user_goes_first
      user_turn
    else
      computer_turn
    end
  end

  def restart_game(user_goes_first)
    (1...20).each { |i| put_line }
    start_game(user_goes_first)
  end
  
  def put_line
    puts ("-" * 40)
  end
  
  def put_bar
    puts ("#" * 40)
    puts ("#" * 40)
  end
  
  def draw_game
    puts ""
    puts " Wins: #{@computer_name}:#{@computer_score} #{@user_name}:#{@user_score}"
    puts ""
    puts " #{@computer_name}: #{@computer}"
    puts " #{@user_name}: #{@user}"
    puts ""
    puts "     A   B   C"
    puts ""
    puts " 1   #{@places[:a1]} | #{@places[:b1]} | #{@places[:c1]} "
    puts "    --- --- ---"
    puts " 2   #{@places[:a2]} | #{@places[:b2]} | #{@places[:c2]} "
    puts "    --- --- ---"
    puts " 3   #{@places[:a3]} | #{@places[:b3]} | #{@places[:c3]} "
  end
  
  def computer_turn
    move = computer_find_move
    @places[move] = @computer
    put_line
    puts " #{@computer_name} marks #{move.to_s.upcase}"
    check_game(@user)
  end
  
  def computer_find_move

    #Check if computer can win
    #Check if any columns already have 2
    @columns.each do |column|
      if times_in_column(column, @computer) == 2
        return empty_in_column column
      end
    end
    
    #Check if user can win
    #Check if any columns already have 2
    @columns.each do |column|
      if times_in_column(column, @user) == 2
        return empty_in_column column
      end
    end
    
    #check if any columns already have 1 for computer
    @columns.each do |column|
      if times_in_column(column, @computer) == 1
        return empty_in_column column
      end
    end
    
    #Find a random empty
    k = @places.keys;
    i = rand(k.length)
    if @places[k[i]] == " "
      return k[i]
    else
      #Just find the first empty slot
      @places.each { |k,v| return k if v == " " }
    end
  end
  
  def times_in_column arr, item
    times = 0
    arr.each do |i| 
      times += 1 if @places[i] == item
      unless @places[i] == item || @places[i] == " "
        #Return 0 as column has opposite piece
        return 0
      end
    end
    times
  end
  
  def empty_in_column arr
    arr.each do |i| 
      if @places[i] == " "
        return i
      end
    end
  end
  
  def user_turn
    put_line
    puts "\n TIC TAC TOE"
    draw_game
    print "\n #{@user_name}, please make a move or type 'exit' to quit: "
    STDOUT.flush
    input = gets.chomp.downcase.to_sym
    put_bar
    if input.length == 2
      a = input.to_s.split("")
      if(['a','b','c'].include? a[0])
        if(['1','2','3'].include? a[1])
          if @places[input] == " "
            @places[input] = @user
            put_line
            puts " #{@user_name} marks #{input.to_s.upcase}"
            check_game(@computer)
          else
            wrong_move
          end
        else
          wrong_input
        end
      else
        wrong_input
      end
    else
      wrong_input unless input == :exit
    end
  end
  
  def wrong_input
    put_line
    puts " Please specify a move with the format 'A1' , 'B3' , 'C2', etc."
    user_turn
  end
  
  def wrong_move
    put_line
    puts "You must choose an empty slot"
    user_turn
  end
  
  def moves_left
    @places.values.select{ |v| v == " " }.length
  end
  
  def check_game(next_turn)
  
    game_over = nil
    
    @columns.each do |column|
      # If Computer Won
      if times_in_column(column, @computer) == 3
        put_line
        draw_game
        put_line
        puts ""
        puts "Game Over -- #{@computer_name} WINS!!!\n"
        game_over = true
        @computer_score += 1
        ask_to_play_again(false)
      end

      # If User Won
      if times_in_column(column, @user) == 3
        put_line
        draw_game
        put_line
        puts ""
        puts "Game Over -- #{@user_name} WINS!!!\n"
        game_over = true
        @user_score += 1
        ask_to_play_again(true)
      end
    end
    
    unless game_over
      if(moves_left > 0)
        if(next_turn == @user)
          user_turn
        else
          computer_turn
        end
      else
        put_line
        draw_game
        put_line
        puts ""
        puts "Game Over -- DRAW!\n"
        ask_to_play_again(rand() > 0.5)
      end
    end
  end

  def ask_to_play_again(user_goes_first)
    print "Play again? (Yn): "
    STDOUT.flush
    response = gets.chomp.downcase
    case response
    when "y"   then restart_game(user_goes_first)
    when "yes" then restart_game(user_goes_first)
    when "n"   then #do nothing
    when "no"  then #do nothing
    else ask_to_play_again(user_goes_first)
    end
  end
  
end