# ConcurrentCalculator

Handcrafted version of elixir gen_server. It shows how tail recursion can be used to created process which runs forever.

It is also show how state can be maintained in a process.

What it does ?
It is a simple stateful calculator where we can fire off requests to add substract, multiply and divide in parallel.

Code is well commented.

iex -S mix

iex(1)> pid = ConcurrentCalculator.start
PID<0.117.0>
iex(2)> ConcurrentCalculator.value(pid)
0
iex(3)> ConcurrentCalculator.add(pid,2)
{:add, 2}
iex(4)> ConcurrentCalculator.mul(pid,2)
{:mul, 2}
iex(5)> ConcurrentCalculator.value(pid)
4
iex(6)> ConcurrentCalculator.mul(pid,8)
{:mul, 8}
iex(7)> ConcurrentCalculator.value(pid)
32
iex(8)>
