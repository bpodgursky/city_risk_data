#!/bin/bash ruby


ND_LOW = 1
ND_MED = 4
ND_HIGH = 6
ND_VHIGH = 8

$natural_disaster_scores = {

    'earthquakes10' => ND_LOW,
    'earthquakes20' => ND_MED,
    'earthquakes50' => ND_HIGH,
    'earthquakes70' => ND_VHIGH,
    'hurricanes-50-land' => ND_LOW,
    'hurricanes-200-land' => ND_MED,
    'hurricanes-400-land' => ND_HIGH,
    'hurricanes-650-land' => ND_VHIGH,

    # cutting tornado in half, because it's a wide area,
    # and really significantly more targeted risk
    'tornado10' => ND_LOW / 2,
    'tornado25' => ND_MED / 2,
    'tornado40' => ND_HIGH / 2,
    'tornado65' => ND_VHIGH / 2,

    'wildfires-1' => ND_LOW,
    'wildfires-2' => ND_MED,
    'wildfires-3' => ND_HIGH,
    'wildfires-4' => ND_VHIGH

}

FIREBALL = 10
AIRBLAST5 = 5
DEGREE3 = 2
AIRBLAST1 = 1

$nuclear_scores = {

    'airports-3rddegree' => DEGREE3,
    'airports-airblast1' => AIRBLAST1,
    'airports-airblast5' => AIRBLAST5,
    'airports-fireball' => FIREBALL,
    'bases-3rddegree' => DEGREE3,
    'bases-airblast1' => AIRBLAST1,
    'bases-airblast5' => AIRBLAST5,
    'bases-fireball' => FIREBALL,
    'capitals-3rddegree' => DEGREE3,
    'capitals-airblast1' => AIRBLAST1,
    'capitals-airblast5' => AIRBLAST5,
    'capitals-fireball' => FIREBALL,
    # going to disable this metric because it is tautological
    # 'cities-3rddegree' => DEGREE3,
    # 'cities-airblast1' => AIRBLAST1,
    # 'cities-airblast5' => AIRBLAST5,
    # 'cities-fireball' => FIREBALL,
    'ports-3rddegree' => DEGREE3,
    'ports-airblast1' => AIRBLAST1,
    'ports-airblast5' => AIRBLAST5,
    'ports-fireball' => FIREBALL,
    'power-3rddegree' => DEGREE3,
    'power-airblast1' => AIRBLAST1,
    'power-airblast5' => AIRBLAST5,
    'power-fireball' => FIREBALL,
    'railyard-3rddegree' => DEGREE3,
    'railyard-airblast1' => AIRBLAST1,
    'railyard-airblast5' => AIRBLAST5,
    'railyard-fireball' => FIREBALL,
    'silo-3rddegree' => DEGREE3,
    'silo-airblast1' => AIRBLAST1,
    'silo-airblast5' => AIRBLAST5,
    'silo-fireball' => FIREBALL,


}


file = File.open(ARGV[0])
header_line = file.readline

headers = {}
headers_rev = {}

header_line.split(",").each_with_index do |value, index|
  headers[index] = value
  headers_rev[value] = index
end


def get_score(layer)

  if $nuclear_scores[layer]
    return $nuclear_scores[layer]
  elsif $natural_disaster_scores[layer]
    return $natural_disaster_scores[layer]
  end

  0

end

puts headers

puts "City,State,Score,Population,Lat,Lng"

file.each do |line|

  city_score = 0

  line_split = line.gsub('"', '').split(",")

  line_split.each_with_index do |value, index|

    header_name = headers[index]

    if value === '1'
      city_score += get_score(header_name)
    end

  end

  puts [line_split[0], line_split[2], city_score,
        line_split[headers_rev['population']],
        line_split[headers_rev['lat']],
        line_split[headers_rev['lng']]].join ","

end
