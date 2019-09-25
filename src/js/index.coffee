app = document.getElementById 'app'
areaID = document.getElementById 'area'
workID = document.getElementById 'work'
scrollTopID = document.getElementById 'scroll-top'

resume = {
  hasWorkCount: 300,
  zone: '',
  job: '',
  # 1 = 地區
  # 2 = 職業
  # 3 = 兩者皆有
  status: '0',
  profileUserData: [],
}

getUrlQueryString = ->
  url = window.location.href
  if url.indexOf('?') != -1
    queryArr1 = url.split('?')[1].split('&')
    queryArr1.forEach (item,index) ->
      if item.split('=')[0] == 'area'
        resume.zone = decodeURI item.split('=')[1]
        resume.status = '1'
        return
      else if item.split('=')[0] == 'job'
        resume.job = decodeURI item.split('=')[1]
        resume.status = '2'
        return
    if resume.zone && resume.job
      resume.status = '3'
  return

getProfile = ->
  profileUrl = 'https://raw.githubusercontent.com/hexschool/Resume/master/profile.json'
  workUrl = 'https://raw.githubusercontent.com/hexschool/Resume/master/findJob.json'

  getWorkAjax = ->
    return $.getJSON(workUrl)
  getProfileAJAX = ->
    return $.getJSON(profileUrl)

  $.when(getWorkAjax(), getProfileAJAX())
    .done (workResult1, profileResult2) ->
      resume.profileUserData = profileResult2[0]
      optionArea(profileResult2[0])
      getWorkPeple(workResult1[0])

      switch(resume.status)
        when '1'
          updateProfile(profileResult2[0], resume.zone)
        when '2'
          updateProfile(profileResult2[0], null, resume.job)
        when '3'
          updateProfile(profileResult2[0], resume.zone, resume.job)
        else
          updateProfile(profileResult2[0])
    .catch (error) ->
      console.log error.responseText
      return
  return

optionArea = (data) ->
  if resume.status == '0'
    newArea = filterArea(data)
    newArea.forEach (item) ->
      options = document.createElement('option')
      options.textContent = item
      area.appendChild(options)
  else
    areaID.remove()

filterArea = (data) ->
  profile = data
  cache = []
  newArea = []

  profile.forEach (item) ->
    cache = cache.concat(item.location)
  newArea = cache.filter (item, index) ->
    cache.indexOf(item) == index

  return newArea;

updateProfile = (profileData, area, job) ->
  str = ''
  console.log resume
  profile = profileData
  newArea = filterArea(profile)

  switch (resume.status)
    when '1'
      str += hopeArea(area)

      profile.forEach (profileItem) ->
        profileItem.location.forEach (item) ->
          if item == area && profileItem.profileUrl
            str += profileCard(profileItem)
      profile.forEach (profileItem) ->
        profileItem.location.forEach (item) ->
          if item == area && !profileItem.profileUrl
            str += profileCard(profileItem)
      app.innerHTML = str
    when '2'
      profile.forEach (profileItem) ->
        profileItem.job.forEach (itemJob) ->
          if itemJob == job && profileItem.profileUrl
            return str += profileCard(profileItem)
      profile.forEach (profileItem) ->
        profileItem.job.forEach (itemJob) ->
          if itemJob == job && !profileItem.profileUrl
            return str += profileCard(profileItem)
      app.innerHTML = str
    when '3'
      str += hopeArea(area)

      profile.forEach (profileItem) ->
        profileItem.location.forEach (itemArea) ->
          profileItem.job.forEach (itemJob) ->
            if itemArea == area && itemJob == job && profileItem.profileUrl
              return str += profileCard(profileItem)
      profileData.forEach (profileItem) ->
        profileItem.location.forEach (itemArea) ->
          profileItem.job.forEach (itemJob) ->
            if itemArea == area && itemJob == job && !profileItem.profileUrl
              return str += profileCard(profileItem)
      app.innerHTML = str
    else
      newArea.forEach (area) ->
        str += hopeArea(area)
        profile.forEach (item) ->
          a = item.location.some (val) ->
            return val == area
          if a && item.profileUrl
            return str += profileCard(item)
        profile.forEach (item) ->
          a = item.location.some (val) ->
            return val == area
          if a && !item.profileUrl
            return str += profileCard(item)
      app.innerHTML = str
  return


getWorkPeple = (data) ->
  return workID.innerHTML = "有 #{resume.hasWorkCount + data.length} 位學員透過六角成功就業囉"

hopeArea = (area) ->
  return "<div class='col-md-12'>
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


getUrlQueryString()
getProfile()
window.addEventListener 'scroll',() ->
  if window.scrollY > 100
    scrollTopID.style.opacity = '1'
  else
    scrollTopID.style.opacity = '0'

areaID.addEventListener 'change', (e) ->
  resume.status = '1'
  if e.target.value == '全部'
    updateProfile(resume.profileUserData)
  else
    updateProfile(resume.profileUserData, e.target.value)

scrollTopID.addEventListener 'click', scrollTopClick