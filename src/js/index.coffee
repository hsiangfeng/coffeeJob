app = document.getElementById 'app'
app = document.getElementById 'app'
areaID = document.getElementById 'area'
scrollTopID = document.getElementById 'scroll-top'

profileUserData = ''

getProfile = ->
  profileUrl = 'https://raw.githubusercontent.com/hexschool/Resume/develop/profile.json'
  fetch profileUrl
    .then (respons) ->
      return respons.json()
    .then (profileData) ->
      profileUserData = profileData
      updateProfile(profileUserData)
      optionArea(profileUserData)
    .catch (error)->
      console.log error

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
    str += "
    <div class='col-md-12'>
      <h3>
        <i class='fas fa-map-marker-alt text-primary'></i>
        他們希望在 <span class='text-primary'>#{area}</span> 工作
      </h3>
      <hr/>
    </div>"
    profile.forEach (item) ->
      a = item.location.some (val) ->
        val == area
      if (a) 
        str += "
          <div class='col-md-6 my-2'>
          <div class='card h-100'>
            <div class='card-body d-flex align-items-stretch'>
              <div class='row flex-row-reverse flex-column'>
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
                <div class='col-lg-7 d-flex flex-column align-self-stretch'>
                  <h5 class='card-title font-weight-bold'>#{item.name}</h5>
                  <div class='profile-location small text-muted'>
                    <i class='fas fa-map-marker-alt'></i>
                    #{item.location.map (itemLocation) ->
                        "<span>#{itemLocation}</span>"
                      .join(' / ')}
                  </div>
                  <div class='text-left'>#{item.job}</div>
                  <p class='card-text profile-description text-muted h-100'>#{item.description}</p>
                  <div class='profile-tags small text-muted'>
                    #{item.tags.map (itemTages) ->
                        "<span class='d-inline-block'>#{itemTages}</span>"
                      .join(' / ')}
                  </div>
                  <div class='profile-connect text-right'>
                    <a href='#{item.profileUrl}' class='btn btn-outline-success btn-block mt-2'>網羅人才</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>"
  app.innerHTML = str

filterProfile = (profile, area) ->
  str = ''
  str += "
  <div class='col-md-12'>
    <h3>
      <i class='fas fa-map-marker-alt text-primary'></i>
      他們希望在 <span class='text-primary'>#{area}</span> 工作
    </h3>
    <hr/>
  </div>"
  profile.forEach (profileItem) ->
    profileItem.location.forEach (item) ->
      if (item == area)
        str += "
        <div class='col-md-6 my-2'>
          <div class='card h-100'>
            <div class='card-body d-flex align-items-stretch'>
              <div class='row flex-row-reverse flex-column'>
                <div class='col-lg-5'>
                  <div class='d-flex flex-column align-items-center'>
                    <div class='profile-user-img-mobile d-md-none' style='background-image: url(#{profileItem.imgUrl})'></div>
                    <div class='profile-user-img d-md-block d-none' style='background-image: url(#{profileItem.imgUrl})'></div>
                    <div class='profile-type text-nowrap smail text-muted'>
                      #{profileItem.type.map (itemType) ->
                        "<span>#{itemType}</span>"
                      .join(' / ')}
                    </div>
                    #{if profileItem.experience != 0 then "<div class='text-muted'>工作經歷 #{profileItem.experience} 年</div>" else ''
                    }
                  </div>
                </div>
                <div class='col-lg-7 d-flex flex-column align-self-stretch'>
                  <h5 class='card-title font-weight-bold'>#{profileItem.name}</h5>
                  <div class='profile-location small text-muted'>
                    <i class='fas fa-map-marker-alt'></i>
                    #{profileItem.location.map (itemLocation) ->
                        "<span>#{itemLocation}</span>"
                      .join(' / ')}
                  </div>
                  <div class='text-left'>#{profileItem.job}</div>
                  <p class='card-text profile-description text-muted h-100'>#{profileItem.description}</p>
                  <div class='profile-tags small text-muted'>
                    #{profileItem.tags.map (itemTages) ->
                        "<span class='d-inline-block'>#{itemTages}</span>"
                      .join(' / ')}
                  </div>
                  <div class='profile-connect text-right'>
                    <a href='#{profileItem.profileUrl}' class='btn btn-outline-success btn-block mt-2'>網羅人才</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>"
  app.innerHTML = str

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