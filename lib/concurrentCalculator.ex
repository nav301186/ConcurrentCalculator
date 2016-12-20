defmodule ConcurrentCalculator do

def start do
  #loop method is the only method in ConcurrentCalculator class which runs in a different process.
  #as here we are using spawn, now all the communication will happen using "send(1,2) "
  spawn(fn ->
    loop(0)
  end)
end

#There is a exchange of information happening between calculator and the client which is iex in this case
def value(server_pid) do
  #this code runs in iex shell, so the iex shell sends a message to the calculator which is running
  #in a different process.
  send(server_pid, {:value, self })
  #calculator responds with a value, after receiving above message
  #we need to read this message from the mailbox by below receive loop.
  receive do
    {:response,value} -> value
  end
end

#Below methods are known as Interface methods
#these methods will run in client process.
#even though these methods are part of same module, but they might run on a different process.

#so this is interesting, since this is going to be called from the client process
#this method will try to target loop function, because this is where the core logic is
#implemented.
#These methods have to follow the the pattern defined in the loop method's receive do loop.
#for example  to hit the  {:add, value} -> current_value + value clause
# add method has to send response in send(server_pid,{:add, value}) format.
def add(server_pid, value) do
  send(server_pid,{:add, value})
end

def sub(server_pid,value) do
  send(server_pid, {:sub, value})
end

def mul(server_pid,value ) do
  send(server_pid,{:mul, value})
end

def div(server_pid,value) do
  send(server_pid,{:div, value})
end

#This is the most interesting method.
#Elixir/erlang uses tail recursion
#as mean for creating long running process.
#below method will loop for infinity and will keep looking for input message.
#below method also maintains a state as new_value.
#so every recursion gives a new state.
  defp loop(current_value) do
    # elixir uses tail recursion
    #which means that this loop will for ever :).
    new_value = receive do
      # pattern match on input.
      #client process is asking for value, send the response to the calling process.
      {:value, caller} -> send(caller, {:response, current_value})
                          current_value

      #calling process is asking to add,sub,mul or div a value to the current state.
      {:add, value} -> current_value + value
      {:sub, value} -> current_value - value
      {:mul, value} -> current_value*value
      {:div, value} -> current_value/value

      invalid_request -> IO.puts "Invalid request #{inspect invalid_request}"
      current_value
  end
  # recursion to keep this process alive forever.
 loop(new_value)

end

end
