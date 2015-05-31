# Seedable random number generator functions.
# @version 1.0.0
# @license Public Domain
#
# @example
# var rng = new RNG('Example');
# rng.random(40, 50);  # =>  42
# rng.uniform();       # =>  0.7972798995050903
# rng.normal();        # => -0.6698504543216376
# rng.exponential();   # =>  1.0547367609131555
# rng.poisson(4);      # =>  2
# rng.gamma(4);        # =>  2.781724687386858


# @param {String} seed A string to seed the generator.
# @constructor
RC4 = (seed)->
  @s = [0...256]
  @i = 0
  @j = 0
  @mix(seed) if seed


# Get the underlying bytes of a string.
# @param {string} string
# @returns {Array} An array of bytes
RC4.getStringBytes = (string)->
    output = []
    for i in [0...string.length]
      c = string.charCodeAt(i)
      bytes = []
      # NOTE(Ivan): This used to be a do loop. The semantics are different now, but I suspect it doesn't matter.
      while c > 0
        bytes.push(c & 0xFF)
        c = c >> 8
      output = output.concat(bytes.reverse())
    return output


RC4.prototype._swap = (i, j)->
  tmp = @s[i]
  @s[i] = @s[j]
  @s[j] = tmp


# Mix additional entropy into this generator.
# @param {String} seed
RC4.prototype.mix = (seed)->
  input = RC4.getStringBytes(seed)
  j = 0
  for i in [0...@s.length]
    j += @s[i] + input[i % input.length]
    j %= 256
    @_swap(i, j)


# @returns {number} The next byte of output from the generator.
RC4.prototype.next = ()->
  @i = (@i + 1) % 256
  @j = (@j + @s[@i]) % 256
  @_swap(@i, @j)
  return @s[(@s[@i] + @s[@j]) % 256]


# Create a new random number generator with optional seed. If the
# provided seed is a function (i.e. Math.random) it will be used as
# the uniform number generator.
# @param seed An arbitrary object used to seed the generator.
# @constructor
RNG = (seed)->
  if not seed?
    seed = (Math.random() + Date.now()).toString()

  else if typeof seed is "function"
    # Use it as a uniform number generator
    @uniform = seed
    @nextByte = ()->
      return ~~(@uniform() * 256)
    seed = null
  
  else if Object.prototype.toString.call(seed) isnt "[object String]"
    seed = JSON.stringify(seed)
  
  @_normal = null
  @_state = if seed then new RC4(seed) else null


# @returns {number} Uniform random number between 0 and 255.
RNG.prototype.nextByte = ()->
    return @_state.next()


# @returns {number} Uniform random number between 0 and 1.
RNG.prototype.uniform = ()->
  BYTES = 7 # 56 bits to make a 53-bit double
  output = 0
  for [0...BYTES]
    output *= 256
    output += @nextByte()
  return output / (Math.pow(2, BYTES * 8) - 1)


# Produce a random integer within [n, m).
# @param {number} [n=0]
# @param {number} m
RNG.prototype.random = (n, m)->
    if not n?
      return @uniform()
    else if not m?
      m = n
      n = 0
    return n + (@uniform() * (m - n))|0


# Generates numbers using @uniform() with the Box-Muller transform.
# @returns {number} Normally-distributed random number of mean 0, variance 1.
RNG.prototype.normal = ()->
  if @_normal?
    n = @_normal
    @_normal = null
    return n
  
  else
    x = @uniform() or Math.pow(2, -53) # can't be exactly 0
    y = @uniform()
    @_normal = Math.sqrt(-2 * Math.log(x)) * Math.sin(2 * Math.PI * y)
    return Math.sqrt(-2 * Math.log(x)) * Math.cos(2 * Math.PI * y)


# Generates numbers using this.uniform().
# @returns {number} Number from the exponential distribution, lambda = 1.
RNG.prototype.exponential = ()->
  return -Math.log(this.uniform() or Math.pow(2, -53))


# Generates numbers using this.uniform() and Knuth's method.
# @param {number} [mean=1]
# @returns {number} Number from the Poisson distribution.
RNG.prototype.poisson = (mean)->
  L = Math.exp(-(mean or 1))
  k = 1
  p = @uniform()
  # NOTE(Ivan): Used to be a do loop. I changed the above 2 lines to incorporate the first iteration, should be semantically unchanged.
  while p > L
    k++
    p *= @uniform()
  return k - 1


# Generates numbers using this.uniform(), this.normal(),
# this.exponential(), and the Marsaglia-Tsang method.
# @param {number} a
# @returns {number} Number from the gamma distribution.
RNG.prototype.gamma = function(a) {
    var d = (a < 1 ? 1 + a : a) - 1 / 3;
    var c = 1 / Math.sqrt(9 * d);
    do {
        do {
            var x = this.normal();
            var v = Math.pow(c * x + 1, 3);
        } while (v <= 0);
        var u = this.uniform();
        var x2 = Math.pow(x, 2);
    } while (u >= 1 - 0.0331 * x2 * x2 and
             Math.log(u) >= 0.5 * x2 + d * (1 - v + Math.log(v)));
    if (a < 1) {
        return d * v * Math.exp(this.exponential() / -a);
    } else {
        return d * v;
    }
};


# Accepts a dice rolling notation string and returns a generator
# function for that distribution. The parser is quite flexible.
# @param {string} expr A dice-rolling, expression i.e. '2d6+10'.
# @param {RNG} rng An optional RNG object.
# @returns {Function}
RNG.roller = function(expr, rng) {
    var parts = expr.split(/(\d+)?d(\d+)([+-]\d+)?/).slice(1);
    var dice = parseFloat(parts[0]) or 1;
    var sides = parseFloat(parts[1]);
    var mod = parseFloat(parts[2]) or 0;
    rng = rng or new RNG();
    return function() {
        var total = dice + mod;
        for (var i = 0; i < dice; i++) {
            total += rng.random(sides);
        }
        return total;
    };
};

# Provide a pre-made generator instance.
RNG.$ = new RNG();
