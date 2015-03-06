
# Think of this as a debounce that remembers intermediate calls and summarizes them instead of throwing them away.
#
# @param  {Function} initial-fn         function that returns initial-state for use with fold and combiner-fn
# @param  {Function} combiner-fn        given an array of arrays of function arguments, fold them into a value that can be used by final-fn
# @param  {Function} final-fn           function to run after nothing has happend for longer than delay milliseconds
# @param  {Number}   delay              milliseconds to wait for inactivity before running final-fn
# @return {Function}                    a function that will collapse and summarize bursts
export burst = (initial-fn, combiner-fn, final-fn, delay) ->
  state = {
    ax: []
    wait: void
    -accumulating
  }
  finish = ->
    initial-value = initial-fn!
    #console.log \finished, { initial-value, ax }
    final = fold combiner-fn, initial-value, state.ax
    #console.log \final, final
    final-fn(final)
    state.ax           := []
    state.accumulating := false
    state.wait         := null

  (...args) ->
    if not state.accumulating
      state.accumulating := true
    else
      clear-timeout state.wait if state.wait
    state.wait := set-timeout finish, delay
    state.ax.push args

# Don't run next unless condition-fn returns true.
#
# @param  {Function} condition-fn       a function that returns true or false based on its args
# @param  {Function} next               if condition-fn returns true, this function is called with the same args
# @return {Function}                    a function that will only run if condition-fn is true
export prereq = (condition-fn, next) ->
  (...args) ->
    if condition-fn ...args
      next ...args

# vim:fdm=indent
