var app, areaID, filterArea, filterProfile, getProfile, optionArea, profileUserData, scrollTopClick, scrollTopID, updateProfile;

app = document.getElementById('app');

app = document.getElementById('app');

areaID = document.getElementById('area');

scrollTopID = document.getElementById('scroll-top');

profileUserData = '';

getProfile = function() {
  var profileUrl;
  profileUrl = 'https://raw.githubusercontent.com/hexschool/Resume/develop/profile.json';
  return fetch(profileUrl).then(function(respons) {
    return respons.json();
  }).then(function(profileData) {
    profileUserData = profileData;
    updateProfile(profileUserData);
    return optionArea(profileUserData);
  }).catch(function(error) {
    return console.log(error);
  });
};

optionArea = function(data) {
  var newArea;
  newArea = filterArea(data);
  return newArea.forEach(function(item) {
    var options;
    options = document.createElement('option');
    options.textContent = item;
    return area.appendChild(options);
  });
};

filterArea = function(data) {
  var cache, newArea, profile;
  profile = data;
  cache = [];
  newArea = [];
  profile.forEach(function(item) {
    return cache = cache.concat(item.location);
  });
  newArea = cache.filter(function(item, index) {
    return cache.indexOf(item) === index;
  });
  return newArea;
};

updateProfile = function(profileData) {
  var newArea, profile, str;
  profile = profileData;
  str = '';
  newArea = filterArea(profile);
  newArea.forEach(function(area) {
    str += `<div class='col-md-12'> <h3> <i class='fas fa-map-marker-alt text-primary'></i> 他們希望在 <span class='text-primary'>${area}</span> 工作 </h3> <hr/> </div>`;
    return profile.forEach(function(item) {
      var a;
      a = item.location.some(function(val) {
        return val === area;
      });
      if (a) {
        return str += `<div class='col-md-6 my-2'> <div class='card h-100'> <div class='card-body d-flex align-items-stretch'> <div class='row flex-row-reverse flex-column'> <div class='col-lg-5'> <div class='d-flex flex-column align-items-center'> <div class='profile-user-img-mobile d-md-none' style='background-image: url(${item.imgUrl})'></div> <div class='profile-user-img d-md-block d-none' style='background-image: url(${item.imgUrl})'></div> <div class='profile-type text-nowrap smail text-muted'> ${item.type.map(function(itemType) {
          return `<span>${itemType}</span>`;
        }).join(' / ')} </div> ${(item.experience !== 0 ? `<div class='text-muted'>工作經歷 ${item.experience} 年</div>` : '')} </div> </div> <div class='col-lg-7 d-flex flex-column align-self-stretch'> <h5 class='card-title font-weight-bold'>${item.name}</h5> <div class='profile-location small text-muted'> <i class='fas fa-map-marker-alt'></i> ${item.location.map(function(itemLocation) {
          return `<span>${itemLocation}</span>`;
        }).join(' / ')} </div> <div class='text-left'>${item.job}</div> <p class='card-text profile-description text-muted h-100'>${item.description}</p> <div class='profile-tags small text-muted'> ${item.tags.map(function(itemTages) {
          return `<span class='d-inline-block'>${itemTages}</span>`;
        }).join(' / ')} </div> <div class='profile-connect text-right'> <a href='${item.profileUrl}' class='btn btn-outline-success btn-block mt-2'>網羅人才</a> </div> </div> </div> </div> </div> </div>`;
      }
    });
  });
  return app.innerHTML = str;
};

filterProfile = function(profile, area) {
  var str;
  str = '';
  str += `<div class='col-md-12'> <h3> <i class='fas fa-map-marker-alt text-primary'></i> 他們希望在 <span class='text-primary'>${area}</span> 工作 </h3> <hr/> </div>`;
  profile.forEach(function(profileItem) {
    return profileItem.location.forEach(function(item) {
      if (item === area) {
        return str += `<div class='col-md-6 my-2'> <div class='card h-100'> <div class='card-body d-flex align-items-stretch'> <div class='row flex-row-reverse flex-column'> <div class='col-lg-5'> <div class='d-flex flex-column align-items-center'> <div class='profile-user-img-mobile d-md-none' style='background-image: url(${profileItem.imgUrl})'></div> <div class='profile-user-img d-md-block d-none' style='background-image: url(${profileItem.imgUrl})'></div> <div class='profile-type text-nowrap smail text-muted'> ${profileItem.type.map(function(itemType) {
          return `<span>${itemType}</span>`;
        }).join(' / ')} </div> ${(profileItem.experience !== 0 ? `<div class='text-muted'>工作經歷 ${profileItem.experience} 年</div>` : '')} </div> </div> <div class='col-lg-7 d-flex flex-column align-self-stretch'> <h5 class='card-title font-weight-bold'>${profileItem.name}</h5> <div class='profile-location small text-muted'> <i class='fas fa-map-marker-alt'></i> ${profileItem.location.map(function(itemLocation) {
          return `<span>${itemLocation}</span>`;
        }).join(' / ')} </div> <div class='text-left'>${profileItem.job}</div> <p class='card-text profile-description text-muted h-100'>${profileItem.description}</p> <div class='profile-tags small text-muted'> ${profileItem.tags.map(function(itemTages) {
          return `<span class='d-inline-block'>${itemTages}</span>`;
        }).join(' / ')} </div> <div class='profile-connect text-right'> <a href='${profileItem.profileUrl}' class='btn btn-outline-success btn-block mt-2'>網羅人才</a> </div> </div> </div> </div> </div> </div>`;
      }
    });
  });
  return app.innerHTML = str;
};

scrollTopClick = function(e) {
  e.preventDefault();
  return window.scrollTo({
    top: 0,
    behavior: "smooth"
  });
};

getProfile();

window.addEventListener('scroll', function() {
  if (window.scrollY > 100) {
    return scrollTopID.style.opacity = '1';
  } else {
    return scrollTopID.style.opacity = '0';
  }
});

areaID.addEventListener('change', function(e) {
  if (e.target.value === '全部') {
    return updateProfile(profileUserData);
  } else {
    return filterProfile(profileUserData, e.target.value);
  }
});

scrollTopID.addEventListener('click', scrollTopClick);

//# sourceMappingURL=index.js.map
