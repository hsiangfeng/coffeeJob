app = document.getElementById 'app'
areaID = document.getElementById 'area'
scrollTopID = document.getElementById 'scroll-top'

profileUserData = ''

getProfile = ->
  profileUrl = 'https://raw.githubusercontent.com/hexschool/Resume/master/profile.json'
  fetch profileUrl
    .then (respons) ->
      return respons.json()
    .then (profileData) ->
      profileUserData = profileData
      updateProfile(profileUserData)
      optionArea(profileUserData)
      return
    .catch (error)->
      console.log error
      return

optionArea = (data) ->
  newArea = filterArea(data)
  newArea.forEach (item) ->
    options = document.createElement('option')
    options.textContent = item
    area.appendChild options

filterArea = (data) ->
  profile = data
  cache = []
  newArea = []

  profile.forEach (item) ->
    cache = cache.concat item.location

  newArea = cache.filter (item, index) ->
    cache.indexOf(item) == index

  return newArea;

updateProfile = (profileData) ->
  profile = profileData
  str = ''
  newArea = filterArea profile
  newArea.forEach (area) ->
    str += hopeArea(area)
    profile.forEach (item) ->
      a = item.location.some (val) ->
        val == area
      if (a) 
        str += profileCard(item)
  app.innerHTML = str

filterProfile = (profile, area) ->
  str = ''
  str += hopeArea(area)
  
  profile.forEach (profileItem) ->
    profileItem.location.forEach (item) ->
      if (item == area)
        str += profileCard(profileItem)
  app.innerHTML = str


hopeArea = (area) ->
  "<div class='col-md-12'>
    <h3>
      <i class='fas fa-map-marker-alt text-primary'></i>
      他們希望在 <span class='text-primary'>#{area}</span> 工作
    </h3>
    <hr/>
  </div>"

profileCard = (item) -> 
  return "<div class='col-md-6 my-2'>
  <div class='card h-100'>
    <div class='card-body'>
      <div class='row flex-row-reverse h-100'>
        <div class='col-lg-5'>
          <div class='d-flex flex-column align-items-center'>
            <div class='profile-user-img-mobile d-md-none' style='background-image: url(#{item.imgUrl})'></div>
            <div class='profile-user-img d-md-block d-none' style='background-image: url(#{item.imgUrl})'></div>
            <div class='profile-type text-nowrap smail text-muted'>
              #{item.type.map (itemType) ->
                  "<span>#{itemType}</span>"
                .join(' / ')}
            </div>
            #{ if item.experience != 0 then "<div class='text-muted'>工作經歷 #{item.experience} 年</div>" else ''}
          </div>
        </div>
        <div class='col-lg-7 d-flex flex-column'>
          <h5 class='card-title font-weight-bold'>#{item.name}</h5>
          <div class='profile-location small text-muted'>
            <i class='fas fa-map-marker-alt'></i>
            #{item.location.map (itemLocation) ->
                "<span>#{itemLocation}</span>"
              .join(' / ')}
          </div>
          <div class='text-left'>#{item.job}</div>
          <p class='card-text profile-description text-muted'>#{item.description}</p>
          <div class='profile-tags small text-muted mt-auto'>
            #{item.tags.map (itemTages) ->
                "<span class='d-inline-block'>#{itemTages}</span>"
              .join(' / ')}
          </div>
          <div class='profile-connect'>
            #{
              if item.profileUrl then "<a href='#{item.profileUrl}' class='btn btn-outline-success btn-block mt-2'>網羅人才</a>" else "<a href='#' class='btn btn-outline-success btn-block mt-2 disabled' tabindex='-1' role='button' aria-disabled='true'><i class='fab fa-angellist'></i> 成功媒合！</a>"
            }
          </div>
        </div>
      </div>
    </div>
  </div>
</div>"


scrollTopClick = (e) ->
  e.preventDefault()
  window.scrollTo
    top: 0,
    behavior: "smooth"

getProfile()

window.addEventListener 'scroll', () ->
  if window.scrollY > 100
    scrollTopID.style.opacity = '1'
  else
    scrollTopID.style.opacity = '0'

areaID.addEventListener 'change', (e) ->
  if e.target.value == '全部'
    updateProfile profileUserData
  else
    filterProfile profileUserData, e.target.value

scrollTopID.addEventListener 'click', scrollTopClick